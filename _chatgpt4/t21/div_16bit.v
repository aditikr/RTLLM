module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    integer i;
    reg [15:0] remainder;
    reg [7:0] partial_dividend;
    reg [15:0] quotient;

    always @(*) begin
        if (B == 0) begin
            quotient = 16'hFFFF; // max value to indicate error, such as a divide by zero
            remainder = 16'h0000;
        end else begin
            // Initialization
            remainder = 0;
            quotient = 0;

            // Step through each bit starting from the most significant bit
            for (i = 15; i >= 0; i = i - 1) begin
                // Shift the remainder left, bring down the next bit of the dividend
                remainder = (remainder << 1) | (A[i]);

                // Set the bit in quotient if remainder is enough for subtraction 
                if (remainder >= B) begin
                    remainder = remainder - B;
                    quotient[i] = 1;
                end else begin
                    quotient[i] = 0;
                end
            end
        end
        // Output assignment
        result = quotient;
        odd = remainder;
    end

endmodule
