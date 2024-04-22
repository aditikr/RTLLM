
module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] quotient;
reg [15:0] remainder;

always @* begin
    a_reg = A;
    b_reg = B;
end

always @* begin
    quotient = 16'b0;
    remainder = 16'b0;

    for (int i = 15; i >= 0; i = i - 1) begin
        remainder = {remainder[14:0], a_reg[15]};
        if (remainder >= b_reg) begin
            quotient[i] = 1;
            remainder = remainder - b_reg;
        end
        a_reg = {a_reg[14:0], 1'b0};
    end

    result = quotient;
    odd = remainder;
end

endmodule
