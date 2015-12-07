module testbench;
  reg clk;
  reg rst;
  initial
     begin
       clk=0;
       #2clk=0;
       forever #2clk=!clk;
     end
  initial	
      begin
           rst = 0;
           #2rst = 1;
           #2rst = 0;     
           #50000 $stop;   
      end  
    MIPS mips(.clk(clk),.rst(rst));
endmodule
