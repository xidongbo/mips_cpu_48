module MEM_WB(clk,IR_W_in,PC4_W_in,AO_W_in,DR_W_in,//in
                 IR_W,PC4_W,AO_W,DR_W);//out
    input clk;
    input [31:0]IR_W_in,PC4_W_in,AO_W_in,DR_W_in;
    output reg [31:0]IR_W,PC4_W,AO_W,DR_W;
    
    always@(posedge clk)
    begin
      IR_W<=IR_W_in;
      PC4_W<=PC4_W_in;
      AO_W<=AO_W_in;
      DR_W<=DR_W_in;
    end
endmodule
