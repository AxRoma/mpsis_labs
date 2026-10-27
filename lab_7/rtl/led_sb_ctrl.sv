module led_sb_ctrl (
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        req_i,
    input  logic        write_enable_i,
    input  logic [31:0] addr_i,
    input  logic [31:0] write_data_i,
    output logic [31:0] read_data_o,
    output logic [15:0] led_o
);

    logic [15:0] led_val;
    logic        led_mode;
    logic [24:0] blink_counter;
    logic        blink_phase;

    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            blink_counter <= 25'd0;
            blink_phase   <= 1'b0;
        end else if (led_mode) begin
            if (blink_counter == 25'd9999999) begin
                blink_counter <= 25'd0;
                blink_phase   <= ~blink_phase;
            end else begin
                blink_counter <= blink_counter + 25'd1;
            end
        end else begin
            blink_counter <= 25'd0;
            blink_phase   <= 1'b0;
        end
    end

    assign led_o = led_mode ? (blink_phase ? led_val : 16'b0) : led_val;

    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            led_val  <= 16'h0000;
            led_mode <= 1'b0;
        end else if (req_i && write_enable_i) begin
            case (addr_i[7:0])
                8'h00: led_val  <= write_data_i[15:0];
                8'h04: led_mode <= write_data_i[0];
                8'h24: if (write_data_i[0]) begin
                    led_val  <= 16'h0000;
                    led_mode <= 1'b0;
                end
                default: ;
            endcase
        end
    end

    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            read_data_o <= 32'h0000_0000;
        end else if (req_i && !write_enable_i) begin
            case (addr_i[7:0])
                8'h00: read_data_o <= {16'h0000, led_val};
                8'h04: read_data_o <= {31'h00000000, led_mode};
                default: read_data_o <= read_data_o;
            endcase
        end
    end

endmodule