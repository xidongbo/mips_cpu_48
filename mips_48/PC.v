module PC(clk,rst,PC_en,PCin,PCout);
 parameter  WIDTH = 32;
 input clk,rst,PC_en;
 input [WIDTH-1:0] PCin;
 output reg[WIDTH-1:0] PCout;
 
 always @(rst)
   PCout<='h00003000;//pc  start address
   
 always @(posedge clk)
    if(PC_en)
      PCout<=PCin;
    else
      PCout<=PCout-4;
 endmodule