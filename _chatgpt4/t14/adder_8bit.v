module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    // XOR gate for sum
    assign sum = a ^ b ^ cin;

    // Carry out
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [8:0] carry;  // Include carry for each bit and the final carry-out

    // Assign the initial carry-in to the first full_adder
    assign carry[0] = cin;

    // Instantiate the 8 full adders
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : FA_BLOCK
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    // Assign the final carry-out from the last full adder
    assign cout = carry[8];

endmodule
