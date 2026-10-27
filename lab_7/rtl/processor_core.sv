module processor_core (
    input  logic        clk_i,
    input  logic        rst_i,

    input  logic        stall_i,
    input  logic [31:0] instr_i,
    input  logic [31:0] mem_rd_i,
    input  logic        irq_req_i,

    output logic [31:0] instr_addr_o,
    output logic [31:0] mem_addr_o,
    output logic [ 2:0] mem_size_o,
    output logic        mem_req_o,
    output logic        mem_we_o,
    output logic [31:0] mem_wd_o,
    output logic        irq_ret_o
);
    
    import decoder_pkg::*;

    // 1. Сначала объявляем внутренние сигналы 
    logic [31:0] program_counter;
    logic [31:0] read_data1;
    logic [31:0] read_data2;
    logic [31:0] wb_data;
    
    logic [31:0] imm_I;
    logic [31:0] imm_U;
    logic [31:0] imm_S;
    logic [31:0] imm_B;
    logic [31:0] imm_J;
    logic [31:0] imm_Z; 

    logic        flag;
    logic [31:0] alu_a;
    logic [31:0] alu_b;
    logic [31:0] alu_result;

    logic [1:0]  wb_sel;
    logic [4:0]  alu_op;
    logic [2:0]  b_sel;
    logic [1:0]  a_sel;
    logic        branch;
    logic        jal;
    logic        jalr;

    logic        gpr_we;
    logic [4:0]  write_addr;
    logic [4:0]  read_addr1;
    logic [4:0]  read_addr2;
    logic        decoder_gpr_we; 

    logic [31:0] branch_or_jump;
    logic        leap; // Нужен ли переход (branch или jal)
    logic [31:0] increased_pc;
    logic [31:0] modified_pc;
    logic [31:0] second_term;
    logic [31:0] jalr_calc_result;
    logic [31:0] jalr_addr;

    logic        csr_we;
    logic        mret;
    logic        illegal_instr; 
    logic        irq;
    logic [2:0]  unused_csr_op;
    logic [31:0] csr_read_data;

    logic [31:0] mie;
    logic [31:0] mepc;
    logic [31:0] mtvec;
    logic [31:0] irq_cause;

    // 2. Назначаем базовые связи (Assigns)
    assign imm_I = {{20{instr_i[31]}}, instr_i[31:20]};
    assign imm_U = {instr_i[31:12], 12'b0};
    assign imm_S = {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
    assign imm_B = {{20{instr_i[31]}}, instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
    assign imm_J = {{12{instr_i[31]}}, instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0};
    assign imm_Z = {27'b0, instr_i[19:15]}; 

    assign mem_wd_o = read_data2;
    assign mem_addr_o = alu_result;

    assign write_addr = instr_i[11: 7];
    assign read_addr1 = instr_i[19:15];
    assign read_addr2 = instr_i[24:20];
    assign gpr_we = decoder_gpr_we & ~stall_i ? 1 : 0; 

    assign branch_or_jump = branch ? imm_B : imm_J;
    assign leap = (flag & branch) | jal;
    assign second_term = leap ? branch_or_jump : 32'd4;

    assign jalr_addr = {jalr_calc_result[31:1], 1'b0};
    assign instr_addr_o = program_counter;

    // 3. Комбинационная логика мультиплексоров
    always_comb begin
        case( a_sel )
            OP_A_RS1:     alu_a = read_data1;
            OP_A_CURR_PC: alu_a = program_counter;
            OP_A_ZERO:    alu_a = 32'b0;
            default:      alu_a = 'x;
        endcase

        case( b_sel )
            OP_B_RS2:   alu_b = read_data2;
            OP_B_IMM_I: alu_b = imm_I;
            OP_B_IMM_U: alu_b = imm_U;
            OP_B_IMM_S: alu_b = imm_S;
            OP_B_INCR:  alu_b = 32'd4;
            default:    alu_b = 'x;
        endcase
    end

    always_comb begin
        if (irq) begin
            modified_pc = mtvec;          
        end else if (mret) begin
            modified_pc = mepc;           
        end else begin
            modified_pc = jalr ? jalr_addr : increased_pc; 
        end
    end

    always_comb begin
        case( wb_sel )
            WB_EX_RESULT: wb_data = alu_result;
            WB_LSU_DATA:  wb_data = mem_rd_i;
            WB_CSR_DATA:  wb_data = csr_read_data; 
            default:      wb_data = 'x;
        endcase
    end

    // 4. Последовательная логика (Регистры)
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            program_counter <= 32'b0;
        end else if (~stall_i) begin
            program_counter <= modified_pc;
        end
    end 

    // 5. Инстанцирование подмодулей
    fulladder32 magnifier (
        .a_i( program_counter ),
        .b_i( second_term ),
        .carry_i( 1'b0 ),
        .sum_o( increased_pc )
    );

    fulladder32 jalr_calculator (
        .a_i( read_data1 ),
        .b_i( imm_I ),
        .carry_i( 1'b0 ),
        .sum_o( jalr_calc_result )
    );

    decoder decoder (
        .fetched_instr_i( instr_i ),
        .a_sel_o( a_sel ),
        .b_sel_o( b_sel ),
        .alu_op_o( alu_op ),
        .csr_op_o( unused_csr_op ),
        .csr_we_o( csr_we ),
        .mem_req_o( mem_req_o ),
        .mem_we_o( mem_we_o ),
        .mem_size_o( mem_size_o ),
        .gpr_we_o( decoder_gpr_we ),
        .wb_sel_o( wb_sel ),
        .illegal_instr_o( illegal_instr ),
        .branch_o( branch ),
        .jal_o( jal ),
        .jalr_o( jalr ),
        .mret_o( mret )
    );

    register_file rf (
        .clk_i( clk_i ),
        .write_enable_i( gpr_we ),
        .write_addr_i( write_addr ),
        .read_addr1_i( read_addr1 ),
        .read_addr2_i( read_addr2 ),
        .write_data_i( wb_data ),
        .read_data1_o( read_data1 ),
        .read_data2_o( read_data2 )
    );

    alu alu (
        .a_i( alu_a ),
        .b_i( alu_b ),
        .alu_op_i( alu_op ),
        .flag_o( flag ),
        .result_o( alu_result )
    );

    interrupt_controller intc (
        .clk_i( clk_i ),
        .rst_i( rst_i ),
        .exception_i( illegal_instr ), 
        .irq_req_i( irq_req_i ),
        .mie_i( |mie ),            
        .mret_i( mret ),
        .irq_ret_o( irq_ret_o ),
        .irq_cause_o( irq_cause ),
        .irq_o( irq )
    );

    csr_controller csr (
        .clk_i( clk_i ),
        .rst_i( rst_i ),
        .trap_i( irq ),              
        .opcode_i( instr_i[14:12] ), 
        .addr_i( instr_i[31:20] ),   
        .pc_i( program_counter ),
        .mcause_i( irq_cause ),
        .rs1_data_i( read_data1 ),
        .imm_data_i( imm_Z ),        
        .write_enable_i( csr_we ),
        .read_data_o( csr_read_data ),
        .mie_o( mie ),
        .mepc_o( mepc ),
        .mtvec_o( mtvec )
    );

endmodule