module instr_mem(
  input  logic [31:0] read_addr_i,
  output logic [31:0] read_data_o
);
  
  import memory_pkg::*;
  
  logic [31:0] ROM [INSTR_MEM_SIZE_WORDS]; //read only memory
  
  initial begin
    $readmemh("init_instr.mem", ROM);
  end
  
  assign read_data_o = ROM[read_addr_i[$clog2(INSTR_MEM_SIZE_BYTES)-1:2]]; // адрес 7 бит чтобы получить
                                                                           // доступ к ячейке с определенным байтом
endmodule