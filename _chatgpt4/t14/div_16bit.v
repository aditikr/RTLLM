module div_16bit(
    input [15:0] A,   // 16-bit dividend
    input [7:0] B,    // 8-bit divisor
    output reg [15:0] result,  // 16-bit quotient
    output reg [15:0] odd     // 16-bit remainder
);

// Temporary variables
reg [15:0] dividend;   // Extended dividend to handle shifts
reg [7:0] divisor;     // Working copy of the divisor
reg [15:0] quotient;   // Temporary quotient
reg [15:0] remainder;  // Temporary remainder
reg [8:0] part_dividend; // Portion of dividend currently compared with divisor
integer i;

always @(*) begin
    dividend = A;
    divisor = B;
    quotient = 0;
    remainder = 0;
    part_dividend = dividend[15:8];

    // Perform division
    for (i = 7; i >= 0; i = i - 1) begin
        if (part_dividend >= divisor) begin
            quotient[i] = 1'b1;
            part_dividend = part_dividend - divisor;
        end else begin
            quotient[i] = 1'b0;
        end
        part_dividend = {part_dividend[7:0], dividend[i-1]}; // Shift in the next bit from the dividend
    end

    remainder = part_dividend;

    // Output assignment
    result = quotient;
    odd = remainder;
end

endmodule
