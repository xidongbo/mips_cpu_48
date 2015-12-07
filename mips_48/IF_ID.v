 module IF_ID(clk,flush,IR_D_en,PC4_D_in,IR_D_in,PC4_D,IR_D);
   parameter WIDTH=32;
   input clk;
   input flush;
   input IR_D_en;//enable sign
   input [WIDTH-1:0] PC4_D_in,IR_D_in;//IF input pc+4 and instraction
   output [WIDTH-1:0] PC4_D,IR_D;//to ID pc+4 and instraction
   
 //IF/ID register
  reg [WIDTH-1:0]  PC4;
  reg [WIDTH-1:0]  IR;
  
  always@(posedge clk)
   begin
     if(!flush)
       begin
      if(IR_D_en)
       begin
         PC4<=PC4_D_in;
         IR<=IR_D_in;
       end 
     end
   else
     begin
       PC4<=0;
       IR<=0;
     end
   end
   
  assign  PC4_D=PC4;
  assign  IR_D=IR;
 endmodule
