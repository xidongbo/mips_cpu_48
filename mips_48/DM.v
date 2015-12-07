module DM(clk,DM_ctrl,A,WD,RD);
  input clk ; // clock
  input [2:0]DM_ctrl;//DM control sign
                     //000:LB
                     //001:LBU
                     //010:LH
                     //011:LHU
                     //100:LW
                     //101:SB
                     //110:SH
                     //111:SW
  input [31:0] A,WD; //address, WRITE DATA  
  output reg [31:0] RD; // READ DATA
  reg [31:0] dm[0:2047];//8k
 
  always @(*)
  case(DM_ctrl)
    3'b000:RD<={{24{dm[A[12:2]][7]}},dm[A[12:2]][7:0]};//lb
    3'b001:RD<={24'b0,dm[A[12:2]][7:0]};//lbu
    3'b010:RD<={{16{dm[A[12:2]][15]}},dm[A[12:2]][15:0]};//lh
    3'b011:RD<={16'b0,dm[A[12:2]][15:0]};//lhu
    3'b100:RD<=dm[A[12:2]];//lw
    3'b101:dm[A[12:2]]<={dm[A[12:2]][31:8],WD[7:0]};//sb
    3'b110:dm[A[12:2]]<={dm[A[12:2]][31:16],WD[15:0]};//sh
    3'b111:dm[A[12:2]]<=WD;//sw
  endcase
endmodule