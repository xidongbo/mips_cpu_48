module FORWARD_ctrl(IR_D,IR_E,IR_M,IR_W,
                    ForwardDRS,ForwardDRT,ForwardERS,ForwardERT,ForwardMRT);
  `define OP 31:26
  `define RS 25:21
  `define RT 20:16
  `define RD 15:11
  `define funct 5:0
    input [31:0]IR_D,IR_E,IR_M,IR_W;
    output  reg[2:0]ForwardDRS,ForwardDRT;
    output reg[1:0]ForwardERS,ForwardERT;
    output reg ForwardMRT;
    
    wire D_RS;//use ID rs data :b_type/jalr/jr
    wire D_RT;//use ID rt data:beq/bne
    wire E_RS;//use EX rs data:cal_r(no sll,srl,sra,jr,jalr,mfhi,mhlo)/cal_i(no LUI)/load/store
    wire E_RT;//use EX rt data:cal_r(no jr,jalr,mfhi,mflo)/store
    wire M_RT;//use MEM rt data:store
    
    wire E_JAL,E_JALR;
    wire M_RD_AO_M;//cal_r(no jr,jalr,mult,multu,div,divu)
    wire M_RT_AO_M;//cal_i(contain LUI)
    wire M_JAL,M_JALR;
    wire W_RD_MUX;//cal_r(no jr,mult,multu,div,divu)
    wire W_RT_MUX;//cal_i(contain LUI),load
    wire W_JAL;
    
    assign D_RS=(IR_D[`OP]==1||(IR_D[`OP]>3&&IR_D[`OP]<8)||(IR_D[`OP]==0&&(IR_D[`funct]==8||IR_D[`funct]==9)))?1:0;
    assign D_RT=(IR_D[`OP]==4||IR_D[`OP]==5)?1:0;
    assign E_RS=((IR_E[`OP]==0&&IR_E[`funct]!=0&&IR_E[`funct]!=2&&IR_E[`funct]!=3&&IR_E[`funct]!=8&&IR_E[`funct]!=9&&IR_E[`funct]!='h10&&IR_E[`funct]!='h12)||
                 (IR_E[`OP]>7&&IR_E[`OP]<'hf)||(IR_E[`OP]>='h20))?1:0;
    assign E_RT=((IR_E[`OP]==0&&IR_E[`funct]!=8&&IR_E[`funct]!=9&&IR_E[`funct]!='h10&&IR_E[`funct]!='h12)||(IR_E[`OP]>'h27))?1:0;
    assign M_RT=(IR_M[`OP]>'h27)?1:0;
    
    assign E_JAL=(IR_E[`OP]==3)?1:0;
    assign E_JALR=(IR_E[`OP]==0&&IR_E[`funct]==9)?1:0;
    assign M_RD_AO_M=(IR_M[`OP]==0&&IR_M[`funct]!=8&&IR_M[`funct]!=9&&IR_M[`funct]!='h18&&IR_M[`funct]!='h19&&IR_M[`funct]!='h1a&&IR_M[`funct]!='h1b)?1:0;
    assign M_RT_AO_M=(IR_M[`OP]>7&&IR_M[`OP]<='hf)?1:0;
    assign M_JAL=(IR_M[`OP]==3)?1:0;
    assign M_JALR=(IR_M[`OP]==0&&IR_M[`funct]==9)?1:0;
    assign W_RD_MUX=(IR_W[`OP]==0&&IR_W[`funct]!=8&&IR_W[`funct]!='h18&&IR_W[`funct]!='h19&&IR_W[`funct]!='h1a&&IR_W[`funct]!='h1b)?1:0;
    assign W_RT_MUX=((IR_W[`OP]>7&&IR_W[`OP]<='hf)||(IR_W[`OP]>='h20&&IR_W[`OP]<='h25))?1:0;
    assign W_JAL=(IR_W[`OP]==3)?1:0;
    
    initial
    begin
      ForwardDRS<=3'b000;
      ForwardDRT<=3'b000;
      ForwardERS<=2'b00;
      ForwardERT<=2'b00;
      ForwardMRT<=0;
    end
    
    always@(*)
    begin
      
       ForwardDRS<=D_RS&&E_JAL&&(IR_D[`RS]==5'b11111)? 3'b001:
                      D_RS&&E_JALR&&(IR_D[`RS]==IR_E[`RD])&&IR_D[`RS]!=0? 3'b001:
                      D_RS&&M_RD_AO_M&&(IR_D[`RS]==IR_M[`RD])&&IR_D[`RS]!=0? 3'b010:
                      D_RS&&M_RT_AO_M&&(IR_D[`RS]==IR_M[`RT])&&IR_D[`RS]!=0? 3'b010:
                      D_RS&&M_JAL&&(IR_D[`RS]==5'b11111)&&IR_D[`RS]!=0? 3'b011:
                      D_RS&&M_JALR&&(IR_D[`RS]==IR_M[`RD])&&IR_D[`RS]!=0? 3'b011:
                      D_RS&&W_RD_MUX&&(IR_D[`RS]==IR_W[`RD])&&IR_D[`RS]!=0? 3'b100:
                      D_RS&&W_RT_MUX&&(IR_D[`RS]==IR_W[`RT])&&IR_D[`RS]!=0? 3'b100:
                      D_RS&&W_JAL&&(IR_D[`RS]==5'b11111)&&IR_D[`RS]!=0? 3'b100:3'b000;
                      
        ForwardDRT<=D_RT&&E_JAL&&(IR_D[`RT]==5'b11111)&&IR_D[`RT]!=0? 3'b001:
                      D_RT&&E_JALR&&(IR_D[`RT]==IR_E[`RD])&&IR_D[`RT]!=0? 3'b001:
                      D_RT&&M_RD_AO_M&&(IR_D[`RT]==IR_M[`RD])&&IR_D[`RT]!=0? 3'b010:
                      D_RT&&M_RT_AO_M&&(IR_D[`RT]==IR_M[`RT])&&IR_D[`RT]!=0? 3'b010:
                      D_RT&&M_JAL&&(IR_D[`RT]==5'b11111)&&IR_D[`RT]!=0? 3'b011:
                      D_RT&&M_JALR&&(IR_D[`RT]==IR_M[`RD])&&IR_D[`RT]!=0? 3'b011:
                      D_RT&&W_RD_MUX&&(IR_D[`RT]==IR_W[`RD])&&IR_D[`RT]!=0? 3'b100:
                      D_RT&&W_RT_MUX&&(IR_D[`RT]==IR_W[`RT])&&IR_D[`RT]!=0? 3'b100:
                      D_RT&&W_JAL&&(IR_D[`RT]==5'b11111)&&IR_D[`RT]!=0? 3'b100:3'b000;
                      
        ForwardERS<=E_RS&&M_RD_AO_M&&(IR_E[`RS]==IR_M[`RD])&&IR_E[`RS]!=0?  2'b01:
                    E_RS&&M_RT_AO_M&&(IR_E[`RS]==IR_M[`RT])&&IR_E[`RS]!=0?  2'b01:
                    E_RS&&M_JAL&&(IR_E[`RS]==5'b11111)&&IR_E[`RS]!=0?  2'b10:
                    E_RS&&M_JALR&&(IR_E[`RS]==IR_M[`RD])&&IR_E[`RS]!=0? 2'b10:
                    E_RS&&W_RD_MUX&&(IR_E[`RS]==IR_W[`RD])&&IR_E[`RS]!=0? 2'b11:
                    E_RS&&W_RT_MUX&&(IR_E[`RS]==IR_W[`RT])&&IR_E[`RS]!=0? 2'b11: 
                    E_RS&&W_JAL&&(IR_E[`RS]==5'b11111)&&IR_E[`RS]!=0? 2'b11:2'b00;    
                    
       ForwardERT<=E_RT&&M_RD_AO_M&&(IR_E[`RT]==IR_M[`RD])&&IR_E[`RT]!=0?  2'b01:
                    E_RT&&M_RT_AO_M&&(IR_E[`RT]==IR_M[`RT])&&IR_E[`RT]!=0?  2'b01:
                    E_RT&&M_JAL&&(IR_E[`RT]==5'b11111)&&IR_E[`RT]!=0?  2'b10:
                    E_RT&&M_JALR&&(IR_E[`RT]==IR_M[`RD])&&IR_E[`RT]!=0? 2'b10:
                    E_RT&&W_RD_MUX&&(IR_E[`RT]==IR_W[`RD])&&IR_E[`RT]!=0? 2'b11:
                    E_RT&&W_RT_MUX&&(IR_E[`RT]==IR_W[`RT])&&IR_E[`RT]!=0? 2'b11: 
                    E_RT&&W_JAL&&(IR_E[`RT]==5'b11111)&&IR_E[`RT]!=0? 2'b11:2'b00;                                                    

       ForwardMRT<=M_RT&&W_RD_MUX&&(IR_M[`RT]==IR_W[`RD])&&IR_M[`RT]!=0? 1:
                   M_RT&&W_RT_MUX&&(IR_M[`RT]==IR_W[`RT])&&IR_M[`RT]!=0? 1:
                   M_RT&&W_JAL&&(IR_M[`RT]==5'b11111)&&IR_M[`RT]!=0? 1:0;              
       end  
    
    
endmodule