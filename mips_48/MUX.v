module MUX2(s,d0,d1,y);
  parameter WIDTH=32;
  input [WIDTH-1:0]d0,d1;
  input s;//select signal
  output reg[WIDTH-1:0]y;
  
  always@(*)
  case(s)
    0:y<=d0;
    1:y<=d1;
    default:y<=d0;
  endcase
endmodule

module MUX3(s,d0,d1,d2,y);
  parameter WIDTH=32;
  input [WIDTH-1:0]d0,d1,d2;
  input [1:0]s;//select signal
  output reg [WIDTH-1:0]y;
  
  always@(*)
  case(s)
    2'b00:y<=d0;
    2'b01:y<=d1;
    2'b10:y<=d2;
    default:y<=d0;
  endcase
endmodule

module MUX4(s,d0,d1,d2,d3,y);
  parameter WIDTH=32;
  input [WIDTH-1:0]d0,d1,d2,d3;
  input [1:0]s;//select signal
  output reg [WIDTH-1:0]y;
  
  always@(*)
  case(s)
    2'b00:y<=d0;
    2'b01:y<=d1;
    2'b10:y<=d2;
    2'b11:y<=d3;
     default:y<=d0;
  endcase
endmodule

module MUX5(s,d0,d1,d2,d3,d4,y);
  parameter WIDTH=32;
  input [WIDTH-1:0]d0,d1,d2,d3,d4;
  input [2:0]s;//select signal
  output reg [WIDTH-1:0]y;
  
  always@(*)
  case(s)
    3'b000:y<=d0;
    3'b001:y<=d1;
    3'b010:y<=d2;
    3'b011:y<=d3;
    3'b100:y<=d4;
     default:y<=d0;
  endcase
endmodule

