module processor_system(
    input  logic        clk_i,
    input  logic        resetn_i,    // активный уровень 0
    input  logic [15:0] sw_i,
    output logic [15:0] led_o,
    input  logic        kclk_i,
    input  logic        kdata_i,
    output logic [ 6:0] hex_led_o,
    output logic [ 7:0] hex_sel_o,
    input  logic        rx_i,
    output logic        tx_o
);

    // Генератор тактовой частоты 10 МГц и внутренний сброс (активный 1)
    logic sysclk, rst;
    sys_clk_rst_gen #(.DIV_WIDTH(5)) divider (
        .ex_clk_i      (clk_i),
        .ex_areset_n_i (resetn_i),
        .div_i         (5'd5),        // 100 МГц / 10 = 10 МГц
        .sys_clk_o     (sysclk),
        .sys_reset_o   (rst)
    );

    // Сигналы между ядром и LSU
    logic        stall;
    logic        core_req;
    logic        core_we;
    logic [2:0]  core_size;
    logic [31:0] core_wd;
    logic [31:0] core_addr;
    logic [31:0] core_rd;

    // Сигналы системной шины (после LSU)
    logic        sys_req;
    logic        sys_we;
    logic [3:0]  sys_be;
    logic [31:0] sys_wd;
    logic [31:0] sys_addr;
    logic [31:0] sys_rd;
    logic        sys_ready;

    // Прерывания
    logic        irq_req;
    logic        irq_ret;

    // Сигналы отдельных устройств
    logic        ram_req, ram_ready;
    logic [31:0] ram_rd;

    logic        led_req;
    logic [31:0] led_rd;

    logic        uart_req;
    logic [31:0] uart_rd;

    logic        sw_req;          // ДОБАВЛЕНО: запрос к переключателям
    logic [31:0] sw_rd;           // ДОБАВЛЕНО: данные от переключателей

    // Память инструкций
    logic [31:0] instr_addr, instr;

    // 1. Дешифратор адреса (старшие 8 бит)
    always_comb begin
        ram_req  = 1'b0;
        led_req  = 1'b0;
        uart_req = 1'b0;
        sw_req   = 1'b0;           // ДОБАВЛЕНО

        if (sys_req) begin
            case (sys_addr[31:24])
                8'h00: ram_req  = sys_req;   // память данных
                8'h01: sw_req   = sys_req;   // переключатели
                8'h02: led_req  = sys_req;   // светодиоды
                8'h05: uart_req = sys_req;   // UART приёмник
                default: ;
            endcase
        end
    end

    // 2. Мультиплексор чтения и сигнала ready
    always_comb begin
        sys_rd    = 32'b0;
        sys_ready = 1'b1;   // по умолчанию

        case (sys_addr[31:24])
            8'h00: begin
                sys_rd    = ram_rd;
                sys_ready = ram_ready;
            end
            8'h01: begin
                sys_rd    = sw_rd;          // ДОБАВЛЕНО
                sys_ready = 1'b1;
            end
            8'h02: begin
                sys_rd    = led_rd;
                sys_ready = 1'b1;
            end
            8'h05: begin
                sys_rd    = uart_rd;
                sys_ready = 1'b1;
            end
            default: ;
        endcase
    end

    // 3. Процессорное ядро
    processor_core core (
        .clk_i        (sysclk),
        .rst_i        (rst),
        .stall_i      (stall),
        .instr_i      (instr),
        .mem_rd_i     (core_rd),
        .instr_addr_o (instr_addr),
        .mem_addr_o   (core_addr),
        .mem_size_o   (core_size),
        .mem_req_o    (core_req),
        .mem_we_o     (core_we),
        .mem_wd_o     (core_wd),
        .irq_req_i    (irq_req),
        .irq_ret_o    (irq_ret)
    );

    // 4. Модуль загрузки/хранения (LSU)
    lsu load_store_unit (
        .clk_i         (sysclk),
        .rst_i         (rst),
        .core_req_i    (core_req),
        .core_we_i     (core_we),
        .core_size_i   (core_size),
        .core_addr_i   (core_addr),
        .core_wd_i     (core_wd),
        .core_rd_o     (core_rd),
        .core_stall_o  (stall),
        .mem_req_o     (sys_req),
        .mem_we_o      (sys_we),
        .mem_be_o      (sys_be),
        .mem_addr_o    (sys_addr),
        .mem_wd_o      (sys_wd),
        .mem_rd_i      (sys_rd),
        .mem_ready_i   (sys_ready)
    );

    // 5. Память данных (RAM)
    data_mem data_storage (
        .clk_i          (sysclk),
        .mem_req_i      (ram_req),
        .write_enable_i (sys_we),
        .byte_enable_i  (sys_be),
        .addr_i         (sys_addr),
        .write_data_i   (sys_wd),
        .read_data_o    (ram_rd),
        .ready_o        (ram_ready)
    );

    // 6. Контроллер светодиодов
    led_sb_ctrl led_controller (
        .clk_i           (sysclk),
        .rst_i           (rst),
        .req_i           (led_req),
        .write_enable_i  (sys_we),
        .addr_i          (sys_addr),
        .write_data_i    (sys_wd),
        .read_data_o     (led_rd),
        .led_o           (led_o)
    );

    // ------------------------------------------------------------------
    // 7. Контроллер UART приёмника
    // ------------------------------------------------------------------
    uart_rx_sb_ctrl uart_controller (
        .clk_i              (sysclk),
        .rst_i              (rst),
        .req_i              (uart_req),
        .write_enable_i     (sys_we),
        .addr_i             (sys_addr),
        .write_data_i       (sys_wd),
        .read_data_o        (uart_rd),
        .interrupt_request_o(irq_req),
        .interrupt_return_i (irq_ret),
        .rx_i               (rx_i)
    );

    // 8. Контроллер переключателей (ДОБАВЛЕНО)
    sw_sb_ctrl sw_controller (
        .clk_i           (sysclk),
        .rst_i           (rst),
        .req_i           (sw_req),
        .write_enable_i  (sys_we),
        .addr_i          (sys_addr),
        .write_data_i    (sys_wd),
        .read_data_o     (sw_rd),
        .sw_i            (sw_i)
    );

    // 9. Память инструкций (ROM)
    instr_mem instruction_storage (
        .read_addr_i (instr_addr),
        .read_data_o (instr)
    );

    // 10. Заглушки для неиспользуемой периферии
    assign tx_o       = 1'b1;
    assign hex_led_o  = 7'b0;
    assign hex_sel_o  = 8'b0;

endmodule