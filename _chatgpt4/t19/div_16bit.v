module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    // Local declarations
    reg [15:0] remainder;
    reg [15:0] quotient;
    reg [15:0] dividend;
    reg [7:0] divisor;
    reg [7:0] high_bits;
    integer i;

    always @* begin
        // Initialize registers
        dividend = A;
        divisor = B;
        remainder = 16'd0;
        quotient = 16'd0;

        // Check if divisor is zero to avoid division by zero error.
        if (divisor != 8'd0) begin
            for (i = 15; i >= 0; i = i - 1) begin
                // Shift remainder left, bring down the next bit from the dividend
                remainder = remainder << 1;
                remainder[0] = dividend[i];

                // Take the most significant 8 bits of the current remainder
                high_bits = remainder[15:8];

                // Compare and subtract if possible
                if (high_bits >= divisor) begin
                    remainder[15:8] = high_bits - divisor;
                    quotient[i] = 1;
                end
            end
        end

        // Set the final outputs
        result = quotient;
        odd = remainder;
    end
endmodule
