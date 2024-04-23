module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    // Internal signal for carry
    wire [8:0] carry;

    // Assign the first carry as the input carry
    assign carry[0] = Cin;

    // Generate sum and carry for each bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_loop
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
            assign y[i] = a[i] ^ b[i] ^ carry[i];
        end
    endgenerate

    // Output the final carry
    assign Co = carry[8];
endmodule
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_mid;

    // Instantiate the first 8-bit adder (lower bits)
    adder_8bit lower_adder(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    // Instantiate the second 8-bit adder (higher bits)
    adder_8bit upper_adder(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule
