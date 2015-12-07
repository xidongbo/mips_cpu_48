module IM(PC,IR);
  parameter  WIDTH=32;
  input [WIDTH-1:0] PC;
  output [WIDTH-1:0] IR;
  reg[WIDTH-1:0] im[0:32767];//  128k
  
  initial 
  begin
    $readmemh("code.txt",im,'h00000c00);//load  instruction
  end
  
  assign IR=im[PC[16:2]];//number PC[12:2] instruction
endmodule