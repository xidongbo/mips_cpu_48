module NPC(type,Br,PC4,I26,NPC_out);
  input type;//0:b type 1:j type
  input Br;//1:branch 0:no branch
  input [31:0]PC4;//next pc
  input [25:0]I26;//b type only use I26[15:0]
  output [31:0]NPC_out;
  
  wire addr;
  
  assign NPC_out=(type==1)? {PC4[31:28],I26,2'b00}:
                  (Br==1)?{14'b0,I26[15:0],2'b00}+PC4:PC4;
endmodule
