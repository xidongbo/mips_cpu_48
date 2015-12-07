module ALU(ALU_ctrl,A,B,ALU_out);
  input [3:0]ALU_ctrl;//control sign
                    //0000(+):ADD/ADDU/ADDI/ADDIU/load/store
                    //0001(-):SUB/SUBU
                    //0010(&):AND/ANDI
                    //0011(|):OR/ORI
                    //0100(^):XOR/XORI
                    //0101(~|):NOR
                    //0110(RT<<RS):SLLV/SLL
                    //0111(RT>>RS):SRLV/SRL
                    //1000($signed(RT)>>>RS):SRAV/SRA
                    //1001(RD=($signed(RS)<$signed(RT))? 1:0):SLT/SLTI
                    //1010(RD=(RS<RT)? 1:0):SLTU/SLTIU
                    //1011(RT<<16):LUI
  input [31:0]A,B;//2 operator number
  output reg [31:0]ALU_out;//result
  
  always@(*)
  begin
    case(ALU_ctrl)
      4'b0000:ALU_out<=A+B;
      4'b0001:ALU_out<=A-B;
      4'b0010:ALU_out<=A&B;
      4'b0011:ALU_out<=A|B;
      4'b0100:ALU_out<=A^B;
      4'b0101:ALU_out<=~(A|B);
      4'b0110:ALU_out<=B<<A[4:0];
      4'b0111:ALU_out<=B>>A[4:0];
      4'b1000:ALU_out<=$signed(B)>>>A[4:0];
      4'b1001:ALU_out<=($signed(A)<$signed(B))?1:0;
      4'b1010:ALU_out<=A<B?1:0;
      4'b1011:ALU_out<=B<<16;
    endcase
  end
endmodule
