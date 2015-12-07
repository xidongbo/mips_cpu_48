module ALU_MD(ALU_MD_ctrl,A,B,ALU_MD_out);
  input [2:0]ALU_MD_ctrl;//3'b000 signed *
                         //3'b001 unsigned *
                         //3'b010 signed /
                         //3'b011 unsigned /
                         //3'b100 mfhi
                         //3'b101 mflo
  input [31:0]A,B;//rs data,rt data
  output [31:0]ALU_MD_out;//hi data or lo data
  
  reg [31:0]hi,lo;
  
  
  always@(*)
  begin
   case(ALU_MD_ctrl)
    3'b000:{hi,lo}<=$signed(A)*$signed(B);
    3'b001:{hi,lo}<=A*B;
    3'b010:
        begin 
          lo<=$signed(A)/$signed(B);
          hi<=$signed(A)%$signed(B);
        end
    3'b011:
        begin 
          lo<=A/B;
          hi<=A%B;
        end
    endcase
 end
   
   assign ALU_MD_out=(ALU_MD_ctrl==3'b100)? hi:lo;
  
endmodule
