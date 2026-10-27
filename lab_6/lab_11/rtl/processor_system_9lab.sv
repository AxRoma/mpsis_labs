module processor_system(
    input logic clk_i,
    input logic rst_i
);

    logic [31:0] instr;
    logic [31:0] instr_addr;

    // --- Управляющие сигналы и шина между Ядром и LSU ---
    logic        stall;
    logic        core_req;
    logic        core_we;
    logic [2:0]  core_size;
    logic [31:0] core_wd;
    logic [31:0] core_addr;
    logic [31:0] core_rd;

    // --- Шина между LSU и Памятью Данных (RAM) ---
    logic        ready;
    logic        mem_req;
    logic        mem_we;
    logic [3:0]  mem_be;
    logic [31:0] mem_wd;
    logic [31:0] mem_addr;
    logic [31:0] mem_rd;
    
    // --- Сигналы прерываний (свободные wire для тестбенча) ---
    logic        irq_req;
    logic        irq_ret;

    // --- Инстанцирование Ядра Процессора ---
    processor_core core(
        .clk_i( clk_i ),
        .rst_i( rst_i ),
        .stall_i( stall ),
        .instr_i( instr ),
        .mem_rd_i( core_rd ),
        
        .instr_addr_o( instr_addr ),
        .mem_addr_o( core_addr ),
        .mem_size_o( core_size ),
        .mem_req_o( core_req ),
        .mem_we_o( core_we ),
        .mem_wd_o( core_wd ),
        
        .irq_req_i( irq_req ),
        .irq_ret_o( irq_ret )
    );

    // --- Инстанцирование Модуля Загрузки/Сохранения (LSU) ---
    lsu load_store_unit(
        .clk_i( clk_i ),
        .rst_i( rst_i ),
        .core_req_i( core_req ),
        .core_we_i( core_we ),
        .core_size_i( core_size ),
        .core_addr_i( core_addr ),
        .core_wd_i( core_wd ),
        .core_rd_o( core_rd ),
        .core_stall_o( stall ),
        .mem_req_o( mem_req ),
        .mem_we_o( mem_we ),
        .mem_be_o( mem_be ),
        .mem_addr_o( mem_addr ),
        .mem_wd_o( mem_wd ),
        .mem_rd_i( mem_rd ),
        .mem_ready_i( ready )
    );

    // --- Инстанцирование Памяти Данных (RAM) ---
    data_mem data_mem(
        .clk_i( clk_i ),
        .mem_req_i( mem_req ),
        .write_enable_i( mem_we ),
        .byte_enable_i( mem_be ),
        .addr_i( mem_addr ),
        .write_data_i( mem_wd ),
        .read_data_o( mem_rd ),
        .ready_o( ready )
    );

    // --- Инстанцирование Памяти Инструкций (ROM) ---
    instr_mem instr_mem(
        .read_addr_i( instr_addr ),
        .read_data_o( instr )
    );

endmodule