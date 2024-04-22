module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [8:0] multiplier; // 9-bit to handle sign extension and additional bit for Booth's algorithm
reg [16:0] multiplicand; // 17-bit to handle double the size of a and sign extension
reg [4:0] ctr; // 5-bit counter for 8 iterations (each handling 2 bits)

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Sign-extend both inputs
        multiplier <= {{1{b[7]}}, b, 1'b0}; // Extra LSB for handling boundary condition
        multiplicand <= {{9{a[7]}}, a}; // Sign-extended multiplicand
        p <= 0;
        ctr <= 0;
        rdy <= 0;
    end else begin
        if (ctr < 8) begin
            case (multiplier[2:0]) // Examine three bits
                3'b001, 3'b010: p <= p + multiplicand; // Add multiplicand
                3'b011: p <= p + (multiplicand << 1); // Add 2 * multiplicand
                3'b100: p <= p - (multiplicand << 1); // Subtract 2 * multiplicand
                3'b101, 3'b110: p <= p - multiplicand; // Subtract multiplicand
                default: p <= p; // No operation for '000' and '111'
            endcase

            // Shift operations
            multiplicand <= multiplicand << 2; // Shift left by 2 positions
            multiplier <= multiplier >> 2; // Logical shift right by 2 positions
            ctr <= ctr + 1;
        end else begin
            rdy <= 1; // Indicate completion
        end
    end
end

endmodule
