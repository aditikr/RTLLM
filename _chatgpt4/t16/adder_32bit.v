module cla_16bit(
    input wire[15:0] A,
    input wire[15:0] B,
    input wire Cin,
    output wire[15:0] S,
    output wire Cout
);
    wire[15:0] G; // Generate
    wire[15:0] P; // Propagate
    wire[16:0] C; // Carry

    // Generate and Propagate calculations
    assign G = A & B;
    assign P = A ^ B;

    // Carry calculations
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    // Extend this pattern appropriately for all bits...

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : looptoGenCarry
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Output sum calculation
    assign S = P ^ C[15:0];
    assign Cout = C[16];

endmodule
module adder_32bit(
    input wire[31:0] A,
    input wire[31:0] B,
    output wire[31:0] S,
    output wire C32
);
    wire carry_intermediate; // Carry between the lower and upper 16-bit adders

    // Lower 16 bits
    cla_16bit lower_adder (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S[15:0]),
        .Cout(carry_intermediate)
    );

    // Upper 16 bits
    cla_16bit upper_adder (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(carry_intermediate),
        .S(S[31:16]),
        .Cout(C32)
    );

endmodule
