module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] remainder
);

    integer i;  // Loop index for bit-by-bit processing

    always_comb begin
        reg [15:0] temp_dividend; // Temporary variable for dividend
        reg [7:0] current_divisor; // Temprary variable for divisor
        reg [15:0] temp_result; // Temporary result storage
        reg [15:0] temp_remainder; // Temporary remainder storage
        
        temp_dividend = A; 
        current_divisor = B;
        temp_result = 16'd0;
        temp_remainder = 16'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            temp_remainder = temp_remainder << 1;  // Shift remainder left by 1
            temp_remainder[0] = temp_dividend[i];  // Set the lowest bit of remainder to current bit of dividend

            // Compare the current bits of remainder with the divisor
            if (temp_remainder >= current_divisor) begin
                temp_remainder = temp_remainder - current_divisor;
                temp_result[i] = 1;  // Set current bit of result to 1
            end
        end
        
        result = temp_result;
        remainder = temp_remainder;
    end
endmodule
