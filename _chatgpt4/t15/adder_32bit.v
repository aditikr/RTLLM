module CLA_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input  Cin,
    output [15:0] S,
    output C16
);
    wire [15:0] P, G;     // Propagate and Generate
    wire [16:0] C;        // Carry includes Cin and carry-out

    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : block
            assign P[i] = A[i] ^ B[i];  // Propagate
            assign G[i] = A[i] & B[i];  // Generate
            assign C[i+1] = G[i] | (P[i] & C[i]); // Carry calculation
        end
    endgenerate

    assign S = P ^ C[15:0];  // Sum calculation
    assign C16 = C[16];      // Carry-out

endmodule
module adder_32bit(
    input  [31:1] A,
    input  [31:1] B,
    output [31:1] S,
    output C32
);
    wire C16;  // The carry out from the lower half that acts as carry in to the upper half

    // Instance of the lower 16 bits CLA
    CLA_16bit lowCLA (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S[15:0]),
        .C16(C16)
    );

    // Instance of the upper 16 bits CLA
    CLA_16bit highCLA (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),
        .S(S[31:16]),
        .C32(C32)
    );

endmodule
