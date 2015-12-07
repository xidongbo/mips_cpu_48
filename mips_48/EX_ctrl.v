module EX_ctrl(IR_E,S_ALU_B,S_AO_M,ALU_ctrl,ALU_MD_ctrl);
  `define OP 31:26
  `define funct 5:0
   input [31:0]IR_E;//input ID_EX instructions
   output S_ALU_B,//0:other instructions(MFERT)
                  //1:cal_i,load,store,LUI(EXT_E)
          S_AO_M;//0:other instructions(ALU)
                 //1:mfhi,mflo(ALU_MD)
                 
   	   
   output [3:0]ALU_ctrl;//4'b0000(+):ADD/ADDU/ADDI/ADDIU/load/store
                    //4'b0001(-):SUB/SUBU
                    //4'b0010(&):AND/ANDI
                    //4'b0011(|):OR/ORI
                    //4'b0100(^):XOR/XORI
                    //4'b0101(~|):NOR
                    //4'b0110(RT<<RS):SLLV/SLL
                    //4'b0111(RT>>RS):SRLV/SRL
                    //4'b1000($signed(RT)>>>RS):SRAV/SRA
                    //4'b1001(RD=($signed(RS)<$signed(RT))? 1:0):SLT/SLTI
                    //4'b1010(RD=(RS<RT)? 1:0):SLTU/SLTIU
                    //4'b1011(RT<<16):LUI
   output [2:0]ALU_MD_ctrl;//3'b000 signed * mult
                         //3'b001 unsigned * multu
                         //3'b010 signed / div
                         //3'b011 unsigned / divu
                         //3'b100 mfhi
                         //3'b101 mflo
    
 	
   	    
    assign S_ALU_B=(IR_E[`OP]>7)?1:0;
    assign S_AO_M=(IR_E[`OP]==0&&(IR_E[`funct]=='h10||IR_E[`funct]=='h12))?1:0;
    assign ALU_ctrl=((IR_E[`OP]==0&&(IR_E[`funct]=='h20||IR_E[`funct]=='h21))||IR_E[`OP]==8||IR_E[`OP]==9||(IR_E[`OP]>='h20))?4'b0000:
                    (IR_E[`OP]==0&&(IR_E[`funct]=='h22||IR_E[`funct]=='h23))? 4'b0001:
                    ((IR_E[`OP]==0&&IR_E[`funct]=='h24)||(IR_E[`OP]=='hc))?4'b0010:
                    ((IR_E[`OP]==0&&IR_E[`funct]=='h25)||(IR_E[`OP]=='hd))?4'b0011:
                    ((IR_E[`OP]==0&&IR_E[`funct]=='h26)||(IR_E[`OP]=='he))?4'b0100:
                    (IR_E[`OP]==0&&IR_E[`funct]=='h27)? 4'b0101:
                    (IR_E[`OP]==0&&(IR_E[`funct]==4||IR_E[`funct]==0))?4'b0110:
                    (IR_E[`OP]==0&&(IR_E[`funct]==6||IR_E[`funct]==2))?4'b0111:
                    (IR_E[`OP]==0&&(IR_E[`funct]==7||IR_E[`funct]==3))?4'b1000:
                    ((IR_E[`OP]==0&&IR_E[`funct]=='h2a)||(IR_E[`OP]=='ha))?4'b1001:
                    ((IR_E[`OP]==0&&IR_E[`funct]=='h2b)||(IR_E[`OP]=='hb))?4'b1010:4'b1011;
    assign ALU_MD_ctrl=(IR_E[`OP]==0&&IR_E[`funct]=='h18)?3'b000:
                       (IR_E[`OP]==0&&IR_E[`funct]=='h19)?3'b001:
                       (IR_E[`OP]==0&&IR_E[`funct]=='h1a)?3'b010:
                       (IR_E[`OP]==0&&IR_E[`funct]=='h1b)?3'b011:
                       (IR_E[`OP]==0&&IR_E[`funct]=='h10)?3'b100:3'b101;
    
endmodule
