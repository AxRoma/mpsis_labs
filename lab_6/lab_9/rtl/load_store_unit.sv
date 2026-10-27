module lsu(
    input logic clk_i,
    input logic rst_i,

    // Интерфейс с ядром
    input  logic        core_req_i,
    input  logic        core_we_i,
    input  logic [ 2:0] core_size_i,
    input  logic [31:0] core_addr_i,
    input  logic [31:0] core_wd_i,
    output logic [31:0] core_rd_o,
    output logic        core_stall_o,

    // Интерфейс с памятью
    output logic        mem_req_o,
    output logic        mem_we_o,
    output logic [ 3:0] mem_be_o,
    output logic [31:0] mem_addr_o,
    output logic [31:0] mem_wd_o,
    input  logic [31:0] mem_rd_i,
    input  logic        mem_ready_i
);
    
    import decoder_pkg::*;
    
    logic stall_reg;
    logic core_stall; 

    assign core_stall = ~(stall_reg & mem_ready_i) & core_req_i;

    assign mem_addr_o = core_addr_i;
    assign mem_req_o = core_req_i;
    assign mem_we_o = core_we_i;
    assign core_stall_o = core_stall;

    always_comb begin
        // STORE
        case( core_size_i )
            LDST_B: begin
                mem_wd_o = {4{core_wd_i[7:0]}};

                case( core_addr_i[1:0] )
                    2'b00: mem_be_o = 4'b0001;
                    2'b01: mem_be_o = 4'b0010;
                    2'b10: mem_be_o = 4'b0100;
                    2'b11: mem_be_o = 4'b1000;
                endcase 
            end

            LDST_H: begin
                mem_wd_o = {2{core_wd_i[15:0]}};

                case( core_addr_i[1] )
                    1'b0: mem_be_o = 4'b0011;
                    1'b1: mem_be_o = 4'b1100;
                endcase
            end

            LDST_W: begin
                mem_wd_o = core_wd_i;
                mem_be_o = 4'b1111;
            end

            default: mem_be_o = 4'b0000;
        endcase

        // LOAD
        case( core_size_i )
            LDST_B: begin
                case( core_addr_i[1:0] )
                    2'b00: core_rd_o = {{24{mem_rd_i[7]}}, mem_rd_i[7:0]};
                    2'b01: core_rd_o = {{24{mem_rd_i[15]}}, mem_rd_i[15:8]};
                    2'b10: core_rd_o = {{24{mem_rd_i[23]}}, mem_rd_i[23:16]};
                    2'b11: core_rd_o = {{24{mem_rd_i[31]}}, mem_rd_i[31:24]};
                endcase
            end
            
            LDST_BU: begin
                case( core_addr_i[1:0] )
                    2'b00: core_rd_o = {24'b0, mem_rd_i[7:0]};
                    2'b01: core_rd_o = {24'b0, mem_rd_i[15:8]};
                    2'b10: core_rd_o = {24'b0, mem_rd_i[23:16]};
                    2'b11: core_rd_o = {24'b0, mem_rd_i[31:24]};
                endcase
            end

            LDST_H: begin
                case( core_addr_i[1] )
                    1'b0: core_rd_o = {{16{mem_rd_i[15]}}, mem_rd_i[15:0]};
                    1'b1: core_rd_o = {{16{mem_rd_i[31]}}, mem_rd_i[31:16]};
                endcase
            end

            LDST_HU: begin
                case( core_addr_i[1] )
                    1'b0: core_rd_o = {16'b0, mem_rd_i[15:0]};
                    1'b1: core_rd_o = {16'b0, mem_rd_i[31:16]};
                endcase
            end

            LDST_W: core_rd_o = mem_rd_i;

            default: core_rd_o = 32'b0;
        endcase
    end

    always_ff @(posedge clk_i) begin
        if( rst_i ) begin
            stall_reg <= 1'b0;
        end else begin
            stall_reg <= core_stall;
        end
    end

endmodule