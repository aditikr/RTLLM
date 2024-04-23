module adder_8bit(
    input  logic [7:0] a,
    input  logic [7:0] b,
    input  logic       Cin,
    output logic [7:0] y,
    output logic       Co
);
    // Adder implementation
    assign {Co, y} = a + b + Cin;
endmodule
module adder_16bit(
    input  logic [15:0] a,
    input  logic [15:0] b,
    input  logic       Cin,
    output logic [15:0] y,
    output logic       Co
);
    logic carry;

    // Instantiating the first 8-bit adder (for LSBs)
    adder_8bit adder_lsb(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry) // Carry output of the lower byte
    );

    // Instantiating the second 8-bit adder (for MSBs)
    adder_8bit adder_msb(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry), // Carry input from the first adder
        .y(y[15:8]),
        .Co(Co) // Carry output of the upper byte
    );
endmodule
