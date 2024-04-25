module adder_8bit(
    input  wire [7:0] a,    // 8-bit input operand A
    input  wire [7:0] b,    // 8-bit input operand B
    input  wire       cin,  // Carry-in input
    output wire [7:0] sum,  // 8-bit sum of A and B
    output wire       cout  // Carry-out
);

    // Internal variables for carry
    wire [8:0] carry;   // wire array to store carry out from each bit addition, carry[8] is cout

    // Assign the first carry input
    assign carry[0] = cin;

    // Generate the full adders
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin: full_adder_gen
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    // Assign carry out
    assign cout = carry[8];

endmodule

module full_adder(
    input  wire a,    // Input bit A
    input  wire b,    // Input bit B
    input  wire cin,  // Input carry
    output wire sum,  // Output sum bit
    output wire cout  // Output carry
);
    // Logic for a single bit full adder
    assign sum = a ^ b ^ cin;      // Sum is the XOR of the two bits and the carry-in
    assign cout = (a & b) | (b & cin) | (a & cin); // Carry-out is generated if any two of the three inputs are high
endmodule
