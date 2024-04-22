module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0] B,   // 8-bit divisor
    output reg [15:0] result,  // 16-bit quotient
    output reg [15:0] odd      // 16-bit remainder
);

    reg [15:0] dividend;
    reg [7:0] divisor;
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [7:0] part_dividend;
    integer i;

    // Handle division logic and edge cases
    always @* begin
        if (B == 0) begin
            // Handle division by zero if required
            quotient = 16'hFFFF;  // Indicative of error or overflow
            remainder = A;        // Return the original dividend as remainder
        end else begin
            dividend = A;
            divisor = B;
            quotient = 0;
            remainder = 0;
            part_dividend = dividend[15:8];  // Extract the top 8 bits of the dividend

            for (i = 7; i >= 0; i = i - 1) begin
                // Compare part of the dividend with the divisor
                if (part_dividend >= divisor) begin
                    quotient = quotient | (1 << (15-i));
                    part_dividend = part_dividend - divisor;
                end
                // Prepare for the next iteration
                part_dividend = {part_dividend[6:0], dividend[i]};
            }
            remainder = {part_dividend, dividend[7:0]};  // Remaining bits form the remainder
        end
        result = quotient;
        odd = remainder;
    end

endmodule
