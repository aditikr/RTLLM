module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    // Internal signal for intermediate values
    wire s1, c1, c2;

    // First stage: sum and carry of a and b
    assign s1 = a ^ b;  // intermediate sum
    assign c1 = a & b;  // intermediate carry

    // Second stage: sum and carry of intermediate sum and cin
    assign sum = s1 ^ cin;        // final sum
    assign c2 = s1 & cin;         // intermediate carry from sum and cin

    // Carry out is the OR of the two carry outputs
    assign cout = c1 | c2;        // final carry out

endmodule

module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Intermediate carries between the full adders
    wire [6:0] carry;

    // Chain of full adders
    full_adder fa0(.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(carry[0]));
    full_adder fa1(.a(a[1]), .b(b[1]), .cin(carry[0]), .sum(sum[1]), .cout(carry[1]));
    full_adder fa2(.a(a[2]), .b(b[2]), .cin(carry[1]), .sum(sum[2]), .cout(carry[2]));
    full_adder fa3(.a(a[3]), .b(b[3]), .cin(carry[2]), .sum(sum[3]), .cout(carry[3]));
    full_adder fa4(.a(a[4]), .b(b[4]), .cin(carry[3]), .sum(sum[4]), .cout(carry[4]));
    full_adder fa5(.a(a[5]), .b(b[5]), .cin(carry[4]), .sum(sum[5]), .cout(carry[5]));
    full_adder fa6(.a(a[6]), .b(b[6]), .cin(carry[5]), .sum(sum[6]), .cout(carry[6]));
    full_adder fa7(.a(a[7]), .b(b[7]), .cin(carry[6]), .sum(sum[7]), .cout(cout));

endmodule
