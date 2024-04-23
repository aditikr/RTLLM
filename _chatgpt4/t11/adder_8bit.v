module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

// Internal wires to carry the carry-out from one full adder to the carry-in of the next
wire [7:0] carry;

// Full adder for bit 0
full_adder fa0 (
    .a(a[0]),
    .b(b[0]),
    .cin(cin),
    .sum(sum[0]),
    .cout(carry[0])
);

// Full adders for bits 1 through 6
genvar i;
generate
    for (i = 1; i < 8; i = i + 1) begin : fa_gen
        full_adder fa (
            .a(a[i]),
            .b(b[i]),
            .cin(carry[i-1]),
            .sum(sum[i]),
            .cout(carry[i])
        );
    end
endgenerate

// Assign the final carry-out
assign cout = carry[7];

endmodule

// Full adder module
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin; // XOR for sum
    assign cout = (a & b) | (b & cin) | (a & cin); // Majority function for carry-out
endmodule
