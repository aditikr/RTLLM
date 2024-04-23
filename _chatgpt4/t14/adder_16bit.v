module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    // Add the two numbers along with the carry-in
    assign {Co, y} = a + b + Cin;
endmodule
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry;  // Intermediate carry between the lower and upper 8-bit adders

    // Instantiate the first 8-bit adder for the lower 8 bits
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry)
    );

    // Instantiate the second 8-bit adder for the upper 8 bits
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry),  // Carry from lower 8-bit result
        .y(y[15:8]),
        .Co(Co)
    );
endmodule
