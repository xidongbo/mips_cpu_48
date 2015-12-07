module EXT(EXT_in,sign,EXT_out);
  input [15:0]EXT_in;
  input sign;//1:sign ext 0:unsign ext
  output [31:0]EXT_out;
  
  assign EXT_out=(sign==1)? {{16{EXT_in[15]}},EXT_in}:{16'b0,EXT_in};
endmodule
