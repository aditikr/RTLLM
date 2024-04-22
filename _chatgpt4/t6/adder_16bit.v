
// Define the 8-bit adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    // Internal signals for sum and carry
    wire [7:0] sum;
    wire [8:0] carry;

    // Generate the sum and carry for each bit
    assign carry[0] = Cin;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_loop
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (b[i] & carry[i]) | (a[i] & carry[i]);
        end
    endgenerate

    // Assign outputs
    assign y = sum;
    assign Co = carry[8];

endmodule

// Define the 16-bit adder module using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Internal signals for the outputs of the first 8-bit adder
    wire [7:0] sum_lower;
    wire carry_out_lower;

    // Internal signals for the outputs of the second 8-bit adder
    wire [7:0] sum_upper;
    wire carry_out_upper;

    // Instantiate the first 8-bit adder for the lower bits
    adder_8bit lower_adder(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_lower),
        .Co(carry_out_lower)
    );

    // Instantiate the second 8-bit adder for the upper bits
    adder_8bit upper_adder(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_out_lower),
        .y(sum_upper),
        .Co(carry_out_upper)
    );

    // Assign the outputs
    assign y[7:0] = sum_lower;
    assign y[15:8] = sum_upper;
    assign Co = carry_out_upper;

endmodule
