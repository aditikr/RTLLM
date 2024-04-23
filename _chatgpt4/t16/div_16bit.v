module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);
    integer i;
    reg [15:0] dividend;
    reg [7:0] divisor;
    reg [15:0] quotient;
    reg [15:0] remainder;

    always @(*) begin
        dividend = A;
        divisor = B;
        quotient = 16'b0;
        remainder = 16'b0;

        for (i = 15; i >= 0; i = i-1) begin
            remainder = (remainder << 1) | (dividend[i]);

            if (remainder >= divisor) begin
                remainder = remainder - divisor;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder;
    end
endmodule
