module EX_MEM(clk,IR_M_in,PC4_M_in,AO_M_in,RT_M_in//input
                 ,IR_M,PC4_M,AO_M,RT_M);//output
   parameter WIDTH=32;
   input clk;
   input [WIDTH-1:0]IR_M_in,PC4_M_in,AO_M_in,RT_M_in;
   output reg [WIDTH-1:0]IR_M,PC4_M,AO_M,RT_M;
  
  always@(posedge clk)
  begin
    IR_M<=IR_M_in;
    PC4_M<=PC4_M_in;
    AO_M<=AO_M_in;
    RT_M<=RT_M_in;
  end
endmodule
