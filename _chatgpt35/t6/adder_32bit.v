
module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    output [15:0] S,
    output C
);

assign P = A ^ B;
assign G = A & B;

assign generate[0] = G[0];
assign propagate[0] = P[0];

genvar i;
generate
    for (i = 1; i < 16; i = i + 1) begin : gen_loop
        assign generate[i] = G[i] | (generate[i-1] & P[i]);
        assign propagate[i] = P[i] | (propagate[i-1] & ~G[i]);
    end
endgenerate

assign C = generate[15];
assign S = A + B;

endmodule

module adder_32bit (
    input [31:0] A,
    input [31:0] B,
    output [31:0] S,
    output C32
);

wire [15:0] carry;
wire [15:0] sum;

cla_16bit cla0 (.A(A[15:0]), .B(B[15:0]), .S(sum[0:15]), .C(carry[0]));
cla_16bit cla1 (.A(A[31:16]), .B(B[31:16]), .S(sum[16:31]), .C(carry[1]));

cla_16bit cla2 (.A(sum[15:0]), .B(carry), .S(S[0:15]), .C(C32));

endmodule
