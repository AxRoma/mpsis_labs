/* -----------------------------------------------------------------------------
 * Модуль контроллера UART-приёмника (uart_rx_sb_ctrl)
 * Соответствует карте памяти (Таблица 6) и описанию ЛР13.
 * Особенности:
 *  - Управление модулем uart_rx
 *  - Регистры: data (R), valid (R), busy (R), baudrate (RW), parity_en (RW), stopbit (RW)
 *  - Прерывание по готовности данных (valid)
 *  - Сброс valid при чтении или возврате из прерывания (если нет нового байта)
 *  - Изменение настроек только когда приёмник не занят (busy=0)
 *  - Программный сброс записью 1 по адресу 0x24
 *  - Синхронное чтение
 * ------------------------------------------------------------------------------
 */
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

    // Регистры контроллера
    logic [7:0]  data;
    logic        valid;
    logic        busy;
    logic [16:0] baudrate;
    logic        parity_en;
    logic [1:0]  stopbit;

    // Сигналы от uart_rx
    logic        rx_valid;
    logic [7:0]  rx_data;
    logic        rx_busy;

    // Сброс для модуля uart_rx (аппаратный + программный)
    logic uart_rst;
    assign uart_rst = rst_i || (req_i && write_enable_i && (addr_i[7:0]==8'h24) && write_data_i[0]);

    // Экземпляр физического приёмника UART
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

    // Регистр busy обновляется каждый такт
    always_ff @(posedge clk_i) begin
        if (rst_i)
            busy <= 1'b0;
        else
            busy <= rx_busy;
    end

    // Приём нового байта от uart_rx
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            data  <= 8'h00;
            valid <= 1'b0;
        end else begin
            if (rx_valid) begin
                data  <= rx_data;
                valid <= 1'b1;
            end else begin
                // Сброс valid при чтении данных или возврате из прерывания,
                // но только если в этом же такте не пришёл новый байт (rx_valid=0)
                if ((req_i && !write_enable_i && (addr_i[7:0]==8'h00)) || interrupt_return_i) begin
                    if (!rx_valid)
                        valid <= 1'b0;
                end
            end
        end
    end

    // Запись в регистры настроек (только когда не занят)
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            baudrate  <= 17'd9600;
            parity_en <= 1'b0;
            stopbit   <= 2'd1;
        end else if (req_i && write_enable_i) begin
            case (addr_i[7:0])
                8'h0C: if (!busy) baudrate  <= write_data_i[16:0];
                8'h10: if (!busy) parity_en <= write_data_i[0];
                8'h14: if (!busy) stopbit   <= write_data_i[1:0];
                8'h24: if (write_data_i[0]) begin   // программный сброс
                    data      <= 8'h00;
                    valid     <= 1'b0;
                    // busy обновится из uart_rx автоматически
                    baudrate  <= 17'd9600;
                    parity_en <= 1'b0;
                    stopbit   <= 2'd1;
                end
                default: ;
            endcase
        end
    end

    // Синхронное чтение регистров
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            read_data_o <= 32'h0000_0000;
        end else if (req_i && !write_enable_i) begin
            case (addr_i[7:0])
                8'h00: read_data_o <= {24'h00_0000, data};
                8'h04: read_data_o <= {31'h0000_0000, valid};
                8'h08: read_data_o <= {31'h0000_0000, busy};
                8'h0C: read_data_o <= {15'h0000, baudrate};
                8'h10: read_data_o <= {31'h0000_0000, parity_en};
                8'h14: read_data_o <= {30'h0000_0000, stopbit};
                default: read_data_o <= read_data_o; // сохраняем предыдущее
            endcase
        end
    end

    // Выход прерывания
    assign interrupt_request_o = valid;

endmodule