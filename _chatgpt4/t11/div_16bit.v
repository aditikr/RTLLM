module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0] B,   // 8-bit divisor
    output reg [15:0] result,  // 16-bit quotient
    output reg [15:0] odd      // 16-bit remainder
);

// Internal registers to hold intermediate values
reg [15:0] dividend;
reg [7:0] divisor;
reg [15:0] quotient;
reg [15:0] remainder;
reg [7:0] high_bits;
integer i;

always @(*) begin
    if (B == 0) begin
        // Handle division by zero case
        quotient = 16'hFFFF;  // Max value to indicate error
        remainder = A;        // Remainder is the dividend itself
    end else begin
        dividend = A;
        divisor = B;
        quotient = 0;
        remainder = 0;

        // Perform division algorithm
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 bit and bring down the next bit of the dividend
            remainder = (remainder << 1) | (dividend[i]);

            // Compare the high bits of remainder with the divisor
            if (remainder[15:8] >= divisor) begin
                remainder = remainder - (divisor << 8);
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end
    end

    // Assign the outputs
    result = quotient;
    odd = remainder;
end

endmodule
