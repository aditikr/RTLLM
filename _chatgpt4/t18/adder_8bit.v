module adder_8bit(
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire cin,
    output wire [7:0] sum,
    output wire cout
);

    wire [8:0] carry;  // Array to hold carry outputs, including carry out from most significant bit

    assign carry[0] = cin;  // Initial carry input 

    // Instantiate full adders for each bit of the operands
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : full_adder_instantiate
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[8];  // Carry out from the top bit

endmodule

// Definition of the full_adder module used in the above 8-bit adder
module full_adder(
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);

    // Internal signal declarations
    wire s1, c1, c2;

    // First stage of full adder
    xor (s1, a, b);
    and (c1, a, b);

    // Second stage of full adder
    xor (sum, s1, cin);
    and (c2, s1, cin);

    // Carry out logic
    or  (cout, c1, c2);

endmodule
