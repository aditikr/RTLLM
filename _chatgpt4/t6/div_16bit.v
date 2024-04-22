
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
    // Initialize registers
    dividend = A;
    divisor = B;
    quotient = 16'd0;
    remainder = 16'd0;

    // Check if divisor is zero to avoid division by zero
    if (divisor != 0) begin
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 bit and bring down the next bit of the dividend
            remainder = (remainder << 1) | (dividend[i]);

            // Extract the higher bits of the current remainder to compare with divisor
            high_bits = remainder[15:8];

            // Compare and subtract if high_bits are greater than or equal to divisor
            if (high_bits >= divisor) begin
                remainder = remainder - (divisor << 8);
                quotient[i] = 1'b1;  // Set the current bit of quotient
            end
        end
    end
    else begin
        // Handle division by zero if required
        quotient = 16'd0;
        remainder = 16'd0;
    end

    // Assign the outputs
    result = quotient;
    odd = remainder;
end

endmodule
