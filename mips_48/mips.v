module MIPS(clk,rst);
  input clk,rst;
  MUX5 MFDRS(.s(FORWARD_ctrl.ForwardDRS),.d0(RF.RF_RD1),.d1(ID_EX.PC4_E),.d2(EX_MEM.AO_M),.d3(EX_MEM.PC4_M),.d4(MTRF_WD.y));
  MUX5 MFDRT(.s(FORWARD_ctrl.ForwardDRT),.d0(RF.RF_RD2),.d1(ID_EX.PC4_E),.d2(EX_MEM.AO_M),.d3(EX_MEM.PC4_M),.d4(MTRF_WD.y));
  MUX4 MFERS(.s(FORWARD_ctrl.ForwardERS),.d0(ID_EX.RS_E),.d1(EX_MEM.AO_M),.d2(EX_MEM.PC4_M),.d3(MTRF_WD.y));
  MUX4 MFERT(.s(FORWARD_ctrl.ForwardERT),.d0(ID_EX.RT_E),.d1(EX_MEM.AO_M),.d2(EX_MEM.PC4_M),.d3(MTRF_WD.y));
  MUX2 MFMRT(.s(FORWARD_ctrl.ForwardMRT),.d0(EX_MEM.RT_M),.d1(MTRF_WD.y));
  
  MUX2 MTCMP_D2(.s(ID_WB_ctrl.S_CMP_D2),.d0(MFDRT.y),.d1(32'b0));
  MUX3 MTPC(.s(ID_WB_ctrl.S_PC),.d0(NPC.NPC_out),.d1(MFDRS.y),.d2(ADD4.PC4));
  MUX2 MTRS_E(.s(ID_WB_ctrl.S_RS_E),.d0(MFDRS.y),.d1({27'b0,IF_ID.IR_D[10:6]}));
  MUX2 MTALU_B(.s(EX_ctrl.S_ALU_B),.d0(MFERT.y),.d1(ID_EX.EXT_E));
  MUX2 MTAO_M(.s(EX_ctrl.S_AO_M),.d0(ALU.ALU_out),.d1(ALU_MD.ALU_MD_out));
  MUX3 #(.WIDTH(5)) MTRF_A3(.s(ID_WB_ctrl.S_RF_A3),.d0(MEM_WB.IR_W[15:11]),.d1(MEM_WB.IR_W[20:16]),.d2(5'b11111));
  MUX3 MTRF_WD(.s(ID_WB_ctrl.S_RF_WD),.d0(MEM_WB.AO_W),.d1(MEM_WB.DR_W),.d2(MEM_WB.PC4_W));
  
  ID_WB_ctrl ID_WB_ctrl(.IR_D(IF_ID.IR_D),.IR_W(MEM_WB.IR_W),.Br(CMP.Br)); //S_CMP_D2,S_PC,S_RS_E,S_RF_A3,S_RF_WD,  //output datapath MUX sign
                                                               // regw,EXT_sign,CMP_sign,NPC_type,IF_ID_flush        //output function parts sign
  EX_ctrl EX_ctrl(.IR_E(ID_EX.IR_E));//S_ALU_B,S_AO_M,ALU_ctrl,ALU_MD_ctrl
  MEM_ctrl MEM_ctrl(.IR_M(EX_MEM.IR_M));//DM_ctrl
  
  PAUSE_ctrl PAUSE_ctrl(.IR_D(IF_ID.IR_D),.IR_E(ID_EX.IR_E),.IR_M(EX_MEM.IR_M));//PC_en,IR_D_en,IR_E_clr
  FORWARD_ctrl FORWARD_ctrl(.IR_D(IF_ID.IR_D),.IR_E(ID_EX.IR_E),.IR_M(EX_MEM.IR_M),.IR_W(MEM_WB.IR_W));//ForwardDRS,ForwardDRT,ForwardERS,ForwardERT,ForwardMRT
  
  PC PC(.clk(clk),.rst(rst),.PC_en(PAUSE_ctrl.PC_en),.PCin(MTPC.y));//PCout
  ADD4 ADD4(.PC(PC.PCout));//PC4
  IM IM(.PC(PC.PCout));//IR
  IF_ID IF_ID(.clk(clk),.flush(ID_WB_ctrl.IF_ID_flush),.IR_D_en(PAUSE_ctrl.IR_D_en),.PC4_D_in(ADD4.PC4),.IR_D_in(IM.IR));//PC4_D,IR_D
  RF RF(.clk(clk),.regw(ID_WB_ctrl.regw),.A1(IF_ID.IR_D[25:21]),.A2(IF_ID.IR_D[20:16]),.A3(MTRF_A3.y),.WD(MTRF_WD.y));//RF_RD1,RF_RD2
  EXT EXT(.EXT_in(IF_ID.IR_D[15:0]),.sign(ID_WB_ctrl.EXT_sign));//EXT_out
  CMP CMP(.D1(MFDRS.y),.D2(MTCMP_D2.y),.sign(ID_WB_ctrl.CMP_sign));//Br
  NPC NPC(.type(ID_WB_ctrl.NPC_type),.Br(CMP.Br),.PC4(IF_ID.PC4_D),.I26(IF_ID.IR_D[25:0]));//NPC_out
  ID_EX ID_EX(.clk(clk),.IR_E_clr(PAUSE_ctrl.IR_E_clr),.IR_E_in(IF_ID.IR_D),.PC4_E_in(IF_ID.PC4_D),
             .RS_E_in(MTRS_E.y),.RT_E_in(MFDRT.y),.EXT_E_in(EXT.EXT_out)); // IR_E,PC4_E,RS_E,RT_E,EXT_E
  ALU ALU(.ALU_ctrl(EX_ctrl.ALU_ctrl),.A(MFERS.y),.B(MTALU_B.y));//ALU_out
  ALU_MD ALU_MD(.ALU_MD_ctrl(EX_ctrl.ALU_MD_ctrl),.A(MFERS.y),.B(MFERT.y));//ALU_MD_out
  EX_MEM EX_MEM(.clk(clk),.IR_M_in(ID_EX.IR_E),.PC4_M_in(ID_EX.PC4_E),.AO_M_in(MTAO_M.y),.RT_M_in(MFERT.y));//IR_M,PC4_M,AO_M,RT_M
  DM DM(.clk(clk),.DM_ctrl(MEM_ctrl.DM_ctrl),.A(EX_MEM.AO_M),.WD(MFMRT.y));//RD
  MEM_WB MEM_WB(.clk(clk),.IR_W_in(EX_MEM.IR_M),.PC4_W_in(EX_MEM.PC4_M),.AO_W_in(EX_MEM.AO_M),.DR_W_in(DM.RD));//IR_W,PC4_W,AO_W,DR_W 
endmodule
