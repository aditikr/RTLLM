module cla_16bit(
    input logic [15:0] A,
    input logic [15:0] B,
    input logic Cin,
    output logic [15:0] S,
    output logic Cout
);
    // Internal signals for generate and propagate
    logic [15:0] G, P;
    logic [16:0] C;

    // Generate and propagate computations
    assign G = A & B;  // Bitwise AND for generate
    assign P = A | B;  // Bitwise OR for propagate

    // Carry computations
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    // Extend this pattern for rest of the bits
    genvar i;
    generate
        for (i = 2; i < 16; i++) begin : carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Sum computation
    assign S = P ^ C[15:0]; // Bitwise XOR for sum
    assign Cout = C[16];  // Final carry out
endmodule
module adder_32bit(
    input logic [31:0] A,
    input logic [31:0] B,
    output logic [31:0] S,
    output logic C32
);
    logic mid_carry;  // Carry out from the lower 16-bit adder to the higher

    // Lower 16 bits
    cla_16bit lower_adder(
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S[15:0]),
        .Cout(mid_carry)
    );

    // Higher 16 bits
    cla_16bit higher_adder(
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(mid_carry),
        .S(S[31:16]),
        .Cout(C32)
    );
endmodule
