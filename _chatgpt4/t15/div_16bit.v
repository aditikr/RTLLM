module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
    );

    reg [15:0] a_reg;
    reg [7:0] b_reg;
    reg [15:0] remainder;
    reg [15:0] quotient;
    reg [8:0] part_dividend;  // Includes one more bit to handle carry over cases

    integer i;

    always @(*) begin
        if (B == 0) begin
            // Division by zero, undefined behavior. Set outputs to high impedance.
            result = 16'bx;
            odd = 16'bx;
        end else begin
            a_reg = A;
            b_reg = B;
            remainder = 0;
            quotient = 0;

            // Start division
            for (i = 15; i >= 0; i = i - 1) begin
                // Shift remainder left by 1 bit and bring down the next bit of the dividend
                remainder = remainder << 1;
                remainder[0] = a_reg[i];

                // Compare remainder with divisor
                part_dividend = remainder[8:0];  // Take MSBs of current remainder + one potential carry bit

                if (part_dividend >= b_reg) begin
                    remainder = remainder - b_reg;
                    quotient[i] = 1'b1;
                end else begin
                    quotient[i] = 1'b0;
                end
            end

            result = quotient;
            odd = remainder;
        end
    end

endmodule
