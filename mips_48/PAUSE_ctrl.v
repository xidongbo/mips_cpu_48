module PAUSE_ctrl(IR_D,IR_E,IR_M,PC_en,IR_D_en,IR_E_clr);
  `define OP 31:26
  `define RS 25:21
  `define RT 20:16
  `define RD 15:11
  `define funct 5:0
  input [31:0]IR_D,//now instruction
              IR_E,//last instruction
              IR_M;//last last instruction
  output reg PC_en,    //forbid PC:  PC.en = !stall
         IR_D_en,   //forbid IF_ID:  IR_D.en = !stall
         IR_E_clr;  //clear ID/EX: IR_E.clr = stall
  wire D_beq_bne;//beq/bne
  wire D_bz;//blez/bgez/bltz/bgtz
  wire D_cal_r;//no sll/srl/sra/jr/jalr/mfhi/mflo
  wire D_s;//sll/srl/sra
  wire D_cal_i;//no LUI
  wire D_load;
  wire D_store;
  wire D_jr;//jalr/jr
  wire E_cal_r_njalr;//no jalr/mult/multu/div/divu
  wire E_cal_i;//contain LUI
  wire E_load;
  wire M_load;
  
  wire stall_be_cal_r;
  wire stall_be_cal_i;
  wire stall_be_load;
  wire stall_be_load_M;
  
  wire stall_bz_cal_r;
  wire stall_bz_cal_i;
  wire stall_bz_load;
  wire stall_bz_load_M;
  
  wire stall_cal_r_load;
  wire stall_s_load;
  wire stall_cal_i_load;
  wire stall_load_load;
  wire stall_store_load;
  wire stall_jr_cal_r;
  wire stall_jr_cal_i;
  wire stall_jr_load;
  wire stall_jr_load_M;
  
  wire stall;
  assign D_beq_bne=(IR_D[`OP]==4||IR_D[`OP]==5)?1:0;
  assign D_bz=(IR_D[`OP]==6||IR_D[`OP]==7||IR_D[`OP]==1)?1:0;
  assign D_cal_r=(IR_D[`OP]==0&&
       (!(IR_D[`funct]<4||IR_D[`funct]==8||IR_D[`funct]==9||IR_D[`funct]=='h10||IR_D[`funct]=='h12)))?1:0;
  assign D_s=(IR_D[`OP]==0&&IR_D[`funct]<4)?1:0;
  assign D_cal_i=(IR_D[`OP]>7&&IR_D[`OP]<'hf)?1:0;
  assign D_load=(IR_D[`OP]>='h20&&IR_D[`OP]<='h25)?1:0;
  assign D_store=(IR_D[`OP]>='h28)?1:0;
  assign D_jr=(IR_D[`OP]==0&&(IR_D[`funct]==8||IR_D[`funct]==9))?1:0;
  
  assign E_cal_r_njalr=(IR_E[`OP]==0&&IR_E[`funct]!=9&&(IR_E[`funct]<='h18||IR_E[`funct]>='h1b))?1:0;
  assign E_cal_i=(IR_E[`OP]>7&&IR_E[`OP]<='hf)?1:0;
  assign E_load=(IR_E[`OP]>='h20&&IR_E[`OP]<='h25)?1:0;
  
  assign M_load=(IR_M[`OP]>='h20&&IR_M[`OP]<='h25)?1:0;
  
  assign stall_be_cal_r=(D_beq_bne&&E_cal_r_njalr&&(IR_D[`RS]==IR_E[`RD]||IR_D[`RT]==IR_E[`RD]))?1:0;
  assign stall_be_cal_i=(D_beq_bne&&E_cal_i&&(IR_D[`RS]==IR_E[`RT]||IR_D[`RT]==IR_E[`RT]))?1:0;
  assign stall_be_load=(D_beq_bne&&E_load&&(IR_D[`RS]==IR_E[`RT]||IR_D[`RT]==IR_E[`RT]))?1:0;
  assign stall_be_load_M=(D_beq_bne&&M_load&&(IR_D[`RS]==IR_M[`RT]||IR_D[`RT]==IR_M[`RT]))?1:0;

  assign stall_bz_cal_r=(D_bz&&E_cal_r_njalr&&IR_D[`RS]==IR_E[`RD])?1:0;
  assign stall_bz_cal_i=(D_bz&&E_cal_i&&IR_D[`RS]==IR_E[`RT])?1:0;
  assign stall_bz_load=(D_bz&&E_load&&IR_D[`RS]==IR_E[`RT])?1:0;
  assign stall_bz_load_M=(D_bz&&M_load&&IR_D[`RS]==IR_M[`RT])?1:0;

  assign stall_cal_r_load=(D_cal_r&&E_load&&(IR_D[`RS]==IR_E[`RT]||IR_D[`RT]==IR_E[`RT]))?1:0; 
  assign stall_s_load=(D_s&&E_load&&(IR_D[`RT]==IR_E[`RT]))?1:0; 
  assign stall_cal_i_load=(D_cal_i&&E_load&&(IR_D[`RS]==IR_E[`RT]))?1:0;
  assign stall_load_load=(D_load&&E_load&&(IR_D[`RS]==IR_E[`RT]))?1:0;
  assign stall_store_load=(D_store&&E_load&&(IR_D[`RS]==IR_E[`RT]))?1:0;
  
  assign stall_jr_cal_r=(D_jr&&E_cal_r_njalr&&(IR_D[`RS]==IR_E[`RD]))?1:0;  
  assign stall_jr_cal_i=(D_jr&&E_cal_i&&(IR_D[`RS]==IR_E[`RT]))?1:0;
  assign stall_jr_load=(D_jr&&E_load&&(IR_D[`RS]==IR_E[`RT]))?1:0;
  assign stall_jr_load_M=(D_jr&&M_load&&(IR_D[`RS]==IR_M[`RT]))?1:0;
  
  assign stall=stall_be_cal_r||stall_be_cal_i||stall_be_load||stall_be_load_M||
               stall_bz_cal_r||stall_bz_cal_i||stall_bz_load||stall_bz_load_M||
               stall_cal_r_load||stall_s_load||stall_cal_i_load||stall_load_load||
               stall_store_load||stall_jr_cal_r||stall_jr_cal_i||stall_jr_load||stall_jr_load_M;
  
  initial
  begin
     PC_en<=1;
     IR_D_en<=1;
     IR_E_clr<=0;
  end
         
  always@(*)
   begin
     PC_en<=!stall;
     IR_D_en<=!stall;
     IR_E_clr<=stall;
   end      
 endmodule
