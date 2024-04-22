module cla_16bit(
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [15:0] G; // Generate
    wire [15:0] P; // Propagate
    wire [16:0] C; // Carry

    // Generate and propagate calculations
    assign G = A & B;
    assign P = A ^ B;

    // Carry calculations
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    // Continue for all bits up to 15
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : carry_logic
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Sum calculation
    assign S = P ^ C[15:0];
    assign Cout = C[16];

endmodule
module adder_32bit(
    input [31:0] A,
    input [31:0] B,
    output [31:0] S,
    output C32
);
    wire C16; // Carry from the lower 16 bits to the upper 16 bits

    // Instance of the lower 16-bit CLA
    cla_16bit lowerCLA (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S[15:0]),
        .Cout(C16)
    );

    // Instance of the upper 16-bit CLA
    cla_16bit upperCLA (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),
        .S(S[31:16]),
        .Cout(C32)
    );

endmodule
