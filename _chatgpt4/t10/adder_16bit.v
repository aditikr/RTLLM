module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    // Internal signals for sum and carry
    wire [8:0] sum;

    // Compute sum and carry
    assign sum = a + b + Cin;

    // Assign outputs
    assign y = sum[7:0];
    assign Co = sum[8];

endmodule
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Internal signals
    wire carry;

    // Instantiate the first 8-bit adder (lower bits)
    adder_8bit lower_adder(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry)  // Carry out from the lower 8 bits
    );

    // Instantiate the second 8-bit adder (upper bits)
    adder_8bit upper_adder(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry),  // Carry in is the carry out from the lower adder
        .y(y[15:8]),
        .Co(Co)  // Final carry out
    );

endmodule
