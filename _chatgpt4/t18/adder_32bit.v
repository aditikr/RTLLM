module cla_16bit(
    input logic [15:0] A,
    input logic [15:0] B,
    input logic Cin,
    output logic [15:0] S,
    output logic Cout
);
    logic [15:0] G, P, C;

    // Generate and Propagate
    assign G = A & B; // Generate
    assign P = A ^ B; // Propagate

    // Carry calculation: Carry Lookahead Logic
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    // Continue this logic for all bits
    genvar i;
    generate
        for (i = 1; i < 16; i++) begin : carry_calc
            assign C[i + 1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign Cout = C[16];
    assign S = P ^ C; // Sum calculation
endmodule
module adder_32bit(
    input logic [31:0] A,
    input logic [31:0] B,
    output logic [31:0] S,
    output logic C32
);
    logic C16; // Intermediate carry between the lower and upper 16-bit blocks

    // Instantiate the lower 16 bits CLA
    cla_16bit lower16 (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S[15:0]),
        .Cout(C16)
    );

    // Instantiate the upper 16 bits CLA
    cla_16bit upper16 (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),
        .S(S[31:16]),
        .Cout(C32)
    );
endmodule
