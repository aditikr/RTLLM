module cla_16bit(
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [15:0] G;      // Generate
    wire [15:0] P;      // Propagate
    wire [16:0] C;      // Carry

    // Generate and propagate signals
    assign G = A & B;
    assign P = A ^ B;
    assign C[0] = Cin;

    // Carry Lookahead Logic
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_logic
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Sum and Carry Out
    assign S = P ^ C[15:0];
    assign Cout = C[16];
endmodule
module adder_32bit(
    input [31:0] A,
    input [31:0] B,
    output [31:0] S,
    output C32
);

    wire C16; // Carry from lower 16 bits to upper 16 bits

    // Lower 16 bits
    cla_16bit lower_half (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),        // No initial carry for the lower half
        .S(S[15:0]),
        .Cout(C16)
    );

    // Upper 16 bits
    cla_16bit upper_half (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),        // Carry from lower half affects the upper half
        .S(S[31:16]),
        .Cout(C32)
    );

endmodule
