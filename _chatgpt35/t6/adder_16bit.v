
module adder_8bit (
    input a,
    input b,
    input Cin,
    output y,
    output Co
);

assign {Co, y} = a + b + Cin;

endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

wire [7:0] carry;
wire [7:0] sum;

adder_8bit adder0 (.a(a[7:0]), .b(b[7:0]), .Cin(Cin), .y(y[7:0]), .Co(carry[0]));
adder_8bit adder1 (.a(a[15:8]), .b(b[15:8]), .Cin(carry[0]), .y(y[15:8]), .Co(carry[1]));

assign Co = carry[1];

endmodule
