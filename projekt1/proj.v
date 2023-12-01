module rca2 (a, b, c, d, x, y);
input a, b, c, d;
output x, y;
wire and1, and2, or3, or4, and5, and6, and7, and8, xor9;

assign and1 = b & c;
assign and2 = b & d;
assign or3 = c | d;
assign or4 = and1 | and2;
assign and5 = b & or3;
assign and6 = a & or4;
assign and7 = a & and5;
assign and8 = and1 & and5 & and6;
assign xor9 = and2 ^ and7;

assign x = and8;
assign y = xor9;
endmodule