module uart_rx_sb_ctrl (
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        req_i,
    input  logic        write_enable_i,
    input  logic [31:0] addr_i,
    input  logic [31:0] write_data_i,
    output logic [31:0] read_data_o,

    output logic        interrupt_request_o,
    input  logic        interrupt_return_i,
    input  logic        rx_i
);

    logic [7:0]  data;
    logic        valid;
    logic [16:0] baudrate;
    logic        parity_en;
    logic [1:0]  stopbit;

    logic        rx_valid;
    logic [7:0]  rx_data;
    logic        rx_busy;

    logic uart_rst;
    assign uart_rst = rst_i || (req_i && write_enable_i && (addr_i[7:0] == 8'h24) && write_data_i[0]);

    // Instantiate UART physical receiver
    uart_rx physical_rx (
        .clk_i      (clk_i),
        .rst_i      (uart_rst),
        .rx_i       (rx_i),
        .busy_o     (rx_busy),
        .baudrate_i (baudrate),
        .parity_en_i(parity_en),
        .stopbit_i  (stopbit),
        .rx_data_o  (rx_data),
        .rx_valid_o (rx_valid)
    );

    // ========================================================================
    // SINGLE always_ff block for all registers (data, valid, baudrate, etc.)
    // ========================================================================
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            // Reset all registers
            data     <= 8'h00;
            valid    <= 1'b0;
            baudrate <= 17'd115200;   // Match testbench (115200 baud)
            parity_en<= 1'b0;
            stopbit  <= 2'd1;
        end else begin
            // --------------------------------------------
            // Handle new data from UART receiver
            // --------------------------------------------
            if (rx_valid) begin
                data  <= rx_data;
                valid <= 1'b1;
            end 
            // --------------------------------------------
            // Handle read or interrupt return (clear valid)
            // --------------------------------------------
            else if ((req_i && !write_enable_i && (addr_i[7:0] == 8'h00)) || interrupt_return_i) begin
                valid <= 1'b0;
            end
            
            // --------------------------------------------
            // Handle writes from CPU (configuration registers)
            // --------------------------------------------
            if (req_i && write_enable_i) begin
                case (addr_i[7:0])
                    8'h0C: if (!rx_busy) baudrate  <= write_data_i[16:0];
                    8'h10: if (!rx_busy) parity_en <= write_data_i[0];
                    8'h14: if (!rx_busy) stopbit   <= write_data_i[1:0];
                    8'h24: if (write_data_i[0]) begin
                        // Software reset
                        data     <= 8'h00;
                        valid    <= 1'b0;
                        baudrate <= 17'd115200;
                        parity_en<= 1'b0;
                        stopbit  <= 2'd1;
                    end
                    default: ;
                endcase
            end
        end
    end

    // ========================================================================
    // Read data multiplexer
    // ========================================================================
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            read_data_o <= 32'h00000000;
        end else if (req_i && !write_enable_i) begin
            case (addr_i[7:0])
                8'h00: read_data_o <= {24'h000000, data};
                8'h04: read_data_o <= {31'h00000000, valid};
                8'h08: read_data_o <= {31'h00000000, rx_busy};
                8'h0C: read_data_o <= {15'h0000, baudrate};
                8'h10: read_data_o <= {31'h00000000, parity_en};
                8'h14: read_data_o <= {30'h00000000, stopbit};
                default: ;
            endcase
        end
    end

    // Interrupt request is just the valid flag
    assign interrupt_request_o = valid;

endmodule