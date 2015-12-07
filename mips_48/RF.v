module RF(clk,regw,A1,A2,A3,WD,RF_RD1,RF_RD2);
  input clk;//,clock
  input  regw;//regwrite signal
  input [4:0] A1,A2,A3;//reg 0-31
  input [31:0]WD;//data write to reg
  output [31:0] RF_RD1,RF_RD2;//data read from reg
  
  reg [31:0]regfile[0:31];//32 reg
  wire [31:0]d1,d2;
  
  initial
  begin
    regfile[0]<=0;
    regfile[29]<='h00002ffc;//sp
    regfile[28]<='h00001800;//gp
    
  end
  
  always @(posedge clk)
  begin
    if(regw) regfile[A3]<=WD;
  end
  
  //first write then read
  assign d1=(regw && A3==A1)? WD:regfile[A1];
  assign d2=(regw && A3==A2)? WD:regfile[A2];
  
  assign RF_RD1=(A1!=0)? d1:0;
  assign RF_RD2=(A2!=0)? d2:0;
endmodule
