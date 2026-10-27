module processor_system(
    input logic clk_i,
    input logic rst_i
);

    logic        mem_we;
    logic        mem_req;
    logic [31:0] mem_addr;
    logic [31:0] mem_wd;

    logic        stall;
    logic        stall_modified;
    logic [31:0] instr;
    logic [31:0] instr_addr;
    logic [31:0] read;

    logic [31:0] read_data;

    assign stall_modified = ~stall & mem_req;

    always_ff @(posedge clk_i) begin
        if(rst_i)
            stall <= 1'b0;
        else
            stall <= stall_modified;
    end

    processor_core core(
        .clk_i( clk_i ),
        .rst_i( rst_i ),
        .stall_i( stall_modified ),
        .instr_i( instr ),
        .mem_rd_i( read_data ),
        .instr_addr_o( instr_addr ),
        .mem_addr_o( mem_addr ),
        .mem_size_o(  ),
        .mem_req_o( mem_req ),
        .mem_we_o( mem_we ),
        .mem_wd_o( mem_wd )
    );

    data_mem data_mem(
        .clk_i( clk_i ),
        .mem_req_i( mem_req ),
        .write_enable_i( mem_we ),
        .byte_enable_i( 4'b1111 ),
        .addr_i( mem_addr ),
        .write_data_i( mem_wd ),
        .read_data_o( read_data ),
        .ready_o(  )
    );

    instr_mem instr_mem(
        .read_addr_i( instr_addr ),
        .read_data_o( instr )
    );

endmodule