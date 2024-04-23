module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    // Temporary registers for quotient bits manipulation and partial remainder.
    reg [15:0] temp_result;
    reg [15:0] temp_remainder;
    reg [15:0] temp_dividend;
    reg [7:0] temp_divisor;
    reg [7:0] high_part;
    integer i;

    always @* begin
        // Initial assignments
        temp_dividend = A;
        temp_divisor = B;
        temp_result = 0;
        temp_remainder = 0;

        // Check for zero divisor
        if (temp_divisor != 0) begin
            for (i = 15; i >= 0; i = i - 1) begin
                // Shift left the current remainder and bring down one bit from the dividend
                temp_remainder = (temp_remainder << 1) | (temp_dividend[i]);

                // Extract top 8 bits for comparison if there are enough bits in remainder
                high_part = temp_remainder[15:8];
                
                // Compare and subtract if possible
                if (high_part >= temp_divisor) begin
                    temp_remainder = temp_remainder - (temp_divisor << 8);
                    temp_result[i] = 1'b1;
                end
                else begin
                    temp_result[i] = 1'b0;
                }
            end
        end
        else begin
            // Handle divide by zero error if needed
            temp_result = 16'hFFFF;  // Indicating error or overflow
            temp_remainder = 16'hFFFF;
        end

        // Assign calculated results to outputs
        result = temp_result;
        odd = temp_remainder;
    end
endmodule
