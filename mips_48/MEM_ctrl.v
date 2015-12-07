module MEM_ctrl(IR_M,DM_ctrl);
  `define OP 31:26
  input [31:0]IR_M;//input  EX_MEM instructions
  output [2:0]DM_ctrl;//DM control sign
                     //000:LB
                     //001:LBU
                     //010:LH
                     //011:LHU
                     //100:LW
                     //101:SB
                     //110:SH
                     //111:SW
  assign DM_ctrl=(IR_M[`OP]=='h20)? 3'b000:
                 (IR_M[`OP]=='h24)? 3'b001:
                 (IR_M[`OP]=='h21)? 3'b010:
                 (IR_M[`OP]=='h25)? 3'b011:
                 (IR_M[`OP]=='h23)? 3'b100:
                 (IR_M[`OP]=='h28)? 3'b101:
                 (IR_M[`OP]=='h29)? 3'b110:
                 (IR_M[`OP]=='h2b)? 3'b111:3'bxxx;
                 
endmodule
