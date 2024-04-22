module cla_4bit(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire [3:0] G; // Generate
    wire [3:0] P; // Propagate
    wire [4:0] C; // Carry

    // Generate and propagate
    assign G = A & B;
    assign P = A ^ B;

    // Carry calculations
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);

    // Sum calculations
    assign S = P ^ C[3:0];
    assign Cout = C[4];

endmodule
module cla_16bit(
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [3:0] carry;

    cla_4bit cla0(
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S[3:0]),
        .Cout(carry[0])
    );

    cla_4bit cla1(
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(carry[0]),
        .S(S[7:4]),
        .Cout(carry[1])
    );

    cla_4bit cla2(
        .A(A[11:8]),
        .B(B[11:8]),
        .Cin(carry[1]),
        .S(S[11:8]),
        .Cout(carry[2])
    );

    cla_4bit cla3(
        .A(A[15:12]),
        .B(B[15:12]),
        .Cin(carry[2]),
        .S(S[15:12]),
        .Cout(Cout)
    );

endmodule
module adder_32bit(
    input [31:0] A,
    input [31:0] B,
    output [31:0] S,
    output C32
);
    wire carry16;

    cla_16bit cla_upper(
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(carry16),
        .S(S[31:16]),
        .Cout(C32)
    );

    cla_16bit cla_lower(
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S[15:0]),
        .Cout(carry16)
    );

endmodule
