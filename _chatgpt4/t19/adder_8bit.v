module adder_8bit(
    input  [7:0] a,
    input  [7:0] b,
    input  logic cin,
    output [7:0] sum,
    output logic cout
);

    // Internal signals to hold carry outputs from each full adder
    logic [7:0] carry;

    // Full adder for bit 0
    full_adder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry[0])
    );

    // Full adders for bits 1 through 7
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin : gen_fa
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    // Carry out of the whole 8-bit adder
    assign cout = carry[7];

endmodule

// Full Adder Module
module full_adder(
     input logic a,
     input logic b,
     input logic cin,
     output logic sum,
     output logic cout
);

    // Full adder logic equations
    assign sum = a ^ b ^ cin;    // Sum is the XOR of the three inputs
    assign cout = (a & b) | (b & cin) | (a & cin);  // Carry out

endmodule
