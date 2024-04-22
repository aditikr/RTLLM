
module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Internal registers
reg [15:0] multiplier;
reg [15:0] multiplicand;
reg [4:0] ctr; // 5-bit counter to handle up to 16 steps

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize registers on reset
        multiplier <= {{8{b[7]}}, b}; // Sign extend to 16 bits
        multiplicand <= {{8{a[7]}}, a}; // Sign extend to 16 bits
        p <= 16'b0;
        ctr <= 0;
        rdy <= 0;
    end else begin
        if (ctr < 16) begin
            // Check the two least significant bits of the multiplier
            case (multiplier[1:0])
                2'b01: p <= p + multiplicand; // +M
                2'b10: p <= p - multiplicand; // -M
                default: p <= p; // No operation or 2'b00 and 2'b11
            endcase

            // Arithmetic shift right (ASR) for signed multiplication
            multiplicand <= multiplicand << 2; // Shift multiplicand left by 2
            multiplier <= {{2{multiplier[15]}}, multiplier[15:2]}; // ASR by 2

            ctr <= ctr + 2; // Increment counter by 2 for Radix-4
        end else begin
            rdy <= 1; // Set ready when done
        end
    end
end

endmodule
