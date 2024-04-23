module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);
    integer i;

    always @(*) begin
        // Local variables to hold interim calculations
        reg [15:0] remainder = 0;
        reg [15:0] quotient = 0;
        reg [15:0] dividend;
        reg [8:0] divisor; // one extra bit for manipulating divisions
        reg [8:0] sub_part;

        dividend = A;
        divisor = {1'b0, B}; // Adding one higher bit for comparison ease

        // Loop from MSB to LSB of the dividend
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left, make space to bring down next bit from the dividend
            remainder = remainder << 1;
            remainder[0] = dividend[i];

            // Check if the partial dividend (remainder) is greater than or equal to divisor
            if (remainder >= divisor) begin
                remainder = remainder - divisor;
                quotient[i] = 1;
            end
            else begin
                quotient[i] = 0;
            end
        end

        // Assign outputs
        result = quotient;
        odd = remainder;
    end
endmodule
