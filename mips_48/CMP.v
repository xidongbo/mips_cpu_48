module CMP(D1,D2,sign,Br);
  input [31:0]D1,D2;
  input [2:0]sign;//
                  //000(BEQ) :D1==D2
                  //001(BNE) :D1!=D2
                  //010(BLEZ) :D1<=D2(D2=0)
                 	//011(BGTZ):D1>D2(D2=0)	
                 	//100(BLTZ) :D1<D2(D2=0)	
                 	//101(BGEZ) :D1>=D2(D2=0)
  output Br;//1:branch 0:no branch
  reg reg_Br;
  
  always@(*)
  case(sign)
    3'b000: reg_Br=($signed(D1)==$signed(D2))? 1:0;
    3'b001: reg_Br=($signed(D1)!=$signed(D2))? 1:0;
    3'b010: reg_Br=($signed(D1)<=$signed(D2))? 1:0;
    3'b011: reg_Br=($signed(D1)>$signed(D2))? 1:0;
    3'b100: reg_Br=($signed(D1)<$signed(D2))? 1:0;
    3'b101: reg_Br=($signed(D1)>=$signed(D2))? 1:0;
  endcase
  
  assign Br=reg_Br;
endmodule
