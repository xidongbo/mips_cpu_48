module ID_EX(clk,IR_E_clr,
           IR_E_in,PC4_E_in,RS_E_in,RT_E_in,EXT_E_in,//input
           IR_E,PC4_E,RS_E,RT_E,EXT_E);//output
   parameter WIDTH=32;
   input clk,IR_E_clr;//clock,1:insert nop
   
   input [WIDTH-1:0]IR_E_in,//instraction
                    PC4_E_in,//pc+4
                    RS_E_in,//rs data
                    RT_E_in,//rt data
                    EXT_E_in;//ext 
   
   output [WIDTH-1:0]IR_E,//instraction
                    PC4_E,//pc+4
                    RS_E,//rs data
                    RT_E,//rt data
                    EXT_E;//ext        
                               
   reg [WIDTH-1:0] IR,PC4,RS,RT,EXT;  
   
   always@(posedge clk)
   begin
     IR<=(IR_E_clr==0)? IR_E_in:32'b0;
     PC4<=PC4_E_in;
     RS<=(IR_E_clr==0)? RS_E_in:32'b0;//?
     RT<=(IR_E_clr==0)? RT_E_in:32'b0;//?
     EXT<=(IR_E_clr==0)? EXT_E_in:32'b0;//?
   end
   
   assign IR_E=IR;
   assign PC4_E=PC4;
   assign RS_E=RS;
   assign RT_E=RT;
   assign EXT_E=EXT;
 endmodule