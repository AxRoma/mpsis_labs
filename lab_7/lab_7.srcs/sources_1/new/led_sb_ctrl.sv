/* -----------------------------------------------------------------------------
 * Модуль контроллера светодиодов (led_sb_ctrl)
 * Соответствует карте памяти (Таблица 3) и описанию ЛР13.
 * Особенности:
 *  - Регистры: led_val (RW, 0x00), led_mode (RW, 0x04)
 *  - Режим "моргания" с периодом 1 с при тактовой частоте 10 МГц
 *  - Программный сброс записью 1 по адресу 0x24
 *  - Синхронное чтение
 * ------------------------------------------------------------------------------
 */
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

    // Внутренние регистры
    logic [15:0] led_val;          // значение на светодиодах
    logic        led_mode;         // 0 - обычный, 1 - моргание
    logic [24:0] blink_counter;    // счётчик для моргания (25 бит, до 2*10^7)

    // Логика счётчика моргания
    logic blink_phase;             // 1 - светодиоды горят, 0 - погашены
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            blink_counter <= 25'd0;
            blink_phase   <= 1'b0;
        end else if (led_mode) begin
            if (blink_counter == 25'd19_999_999) begin  // 2*10^7 - 1
                blink_counter <= 25'd0;
                blink_phase   <= ~blink_phase;
            end else begin
                blink_counter <= blink_counter + 1;
            end
        end else begin
            blink_counter <= 25'd0;
            blink_phase   <= 1'b0;
        end
    end

    // Выход на светодиоды
    assign led_o = led_mode ? (blink_phase ? led_val : 16'b0) : led_val;

    // Обработка запросов записи (синхронно)
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            led_val  <= 16'h0000;
            led_mode <= 1'b0;
        end else if (req_i && write_enable_i) begin
            case (addr_i[7:0])
                8'h00: led_val <= write_data_i[15:0];      // запись данных
                8'h04: led_mode <= write_data_i[0];        // режим моргания
                8'h24: if (write_data_i[0]) begin          // программный сброс
                    led_val  <= 16'h0000;
                    led_mode <= 1'b0;
                    // счётчик сбросится автоматически, т.к. led_mode=0
                end
                default: ; // игнорируем запись по другим адресам
            endcase
        end
    end

    // Синхронное чтение регистров
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            read_data_o <= 32'h0000_0000;
        end else if (req_i && !write_enable_i) begin
            case (addr_i[7:0])
                8'h00: read_data_o <= {16'h0000, led_val};
                8'h04: read_data_o <= {31'h0000_0000, led_mode};
                default: read_data_o <= read_data_o; // сохраняем предыдущее значение
            endcase
        end
        // Если нет активного чтения, значение на read_data_o не меняется
    end

endmodule