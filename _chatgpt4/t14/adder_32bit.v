module adder_32bit (
    input [31:0] A,
    input [31:0] B,
    output [31:0] S,
    output C32
);

    wire C16;  // Carry output from the lower 16 bits to the upper 16 bits

    // Instance of the lower 16-bit CLA
    cla_16bit add_lower (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S[15:0]),
        .Cout(C16)
    );

    // Instance of the upper 16-bit CLA
    cla_16bit add_upper (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),
        .S(S[31:16]),
        .Cout(C32)
    );

endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [15:0] G;  // Generate
    wire [15:0] P;  // Propagate
    wire [16:0] C;  // Carry

    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_prop_blocks
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] ^ B[i];
            assign S[i] = P[i] ^ C[i];
        end
    endgenerate

    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_blocks
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign Cout = C[16];

endmodule
