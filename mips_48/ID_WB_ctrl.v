module ID_WB_ctrl(IR_D,IR_W,//input IF_ID AND MEM_WB instructions
                  Br,
                  S_CMP_D2,S_PC,S_RS_E,S_RF_A3,S_RF_WD,//output datapath MUX sign
                  regw,EXT_sign,CMP_sign,NPC_type,IF_ID_flush);//output function parts sign
      `define OP 31:26
      `define funct 5:0
      `define RT 20:16
      input [31:0]IR_D,IR_W;
      input Br;
      output S_CMP_D2,//0:other instructions(MFDRT) 1:BLEZ,BGTZ,BLTZ,BGEZ(0X00000000)
             S_RS_E,//0:other instructions(MFDRS) 1:SLL,SRL,SRA(IR_D[32shamt])
             
             
             EXT_sign,//1:other instructions(sign ext) 0:ANDI,ORI,XORI(unsign ext)
             NPC_type,//0:b type instructions 1:j type instructions
             IF_ID_flush;//B(branch),j:clear IF/ID
      output reg regw;//0:b_type,store,J,JR 1:other instructions   IR_W!!!!
      output reg[1:0]S_PC;//00:b_type,J,JAL(NPC)
                       //01:JALR,JR(MFDRS)
                       //10:other instructions(ADD4)
     output [1:0]S_RF_A3,//00:other instructions(rd)    IR_W!!!!
                        //01:cal_i,load,LUI(rt)
                        //10:JAL($RA31)
                S_RF_WD;//00:other instructions(AO_W)   IR_W!!!!
                        //01:load(DR_W)
                        //10:JAL,JALR(PC4_W)
      output [2:0]CMP_sign;//000(BEQ) :D1==D2
                          //001(BNE) :D1!=D2
                          //010(BLEZ) :D1<=D2(D2=0)
                 	        //011(BGTZ):D1>D2(D2=0)	
                 	        //100(BLTZ) :D1<D2(D2=0)	
                         	//101(BGEZ) :D1>=D2(D2=0)
      
       	wire B0;//BLEZ,BGTZ,BLTZ,BGEZ
       	wire S;//SLL,SRL,SRA
       	wire B_type;
       	wire store;
       	wire B_type_W;
       	wire store_W;
       	
       	initial
       	begin
       	  S_PC<=2'b10;
       	  regw<=0;
     	  end
     	  
       	assign B0=((IR_D[`OP]==6'b000110)||(IR_D[`OP]==6'b000111)||(IR_D[`OP]==6'b000001))? 1:0;
       	assign S_CMP_D2=B0? 1:0;
   	    assign S=(IR_D[`OP]==6'b0&&(IR_D[`funct]==6'b0||IR_D[`funct]==6'b000010||IR_D[`funct]==6'b000011))? 1:0;
   	    assign S_RS_E=S? 1:0;
 	      assign B_type=((IR_D[`OP]>3&&IR_D[`OP]<8)||IR_D[`OP]==1)? 1:0;
 	      assign store=(IR_D[`OP]>'h27)? 1:0;
 	      assign B_type_W=((IR_W[`OP]>3&&IR_W[`OP]<8)||IR_W[`OP]==1)? 1:0;
 	      assign store_W=(IR_W[`OP]>'h27)? 1:0;
 	      always@(*)
 	      begin
 	        regw<=!(B_type_W||store_W||IR_W[`OP]==2||(IR_W[`OP]==6'b0&&IR_W[`funct]==8))? 1:0;
 	        end
       	assign EXT_sign=((IR_D[`OP]=='hc)||(IR_D[`OP]=='hd)||(IR_D[`OP]=='he))? 0:1;
       	assign NPC_type=B_type? 0:1;
       	always@(*)
       	begin
       	 S_PC<=(B_type||IR_D[`OP]==2||IR_D[`OP]==3)?2'b00:
       	            (IR_D[`OP]==0&&(IR_D[`funct]==8||IR_D[`funct]==9))?2'b01:2'b10;
 	       end
       	assign S_RF_A3=(IR_W[`OP]==3)? 2'b10:
   	                    ((IR_W[`OP]>7&&IR_W[`OP]<='hf)||(IR_W[`OP]>='h20&&IR_W[`OP]<'h26))? 2'b01:2'b00;
 	      assign S_RF_WD=(IR_W[`OP]>='h20&&IR_W[`OP]<'h26)? 2'b01:
 	                      (IR_W[`OP]==3||(IR_W[`OP]==0&&IR_W[`funct]==9))? 2'b10:2'b00;     	
        assign CMP_sign=(IR_D[`OP]==4)? 3'b000:
                        (IR_D[`OP]==5)? 3'b001:
                        (IR_D[`OP]==6)? 3'b010:
                        (IR_D[`OP]==7)? 3'b011:
                        (IR_D[`OP]==1&&IR_D[`RT]==0)? 3'b100:3'b101;
        assign IF_ID_flush=(NPC_type||Br)&&S_PC==2'b00 ?1:0;
endmodule


