module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplier, multiplicand;
reg [4:0] ctr;
reg [1:0] booth_code;
wire [15:0] sum, sub;

// Sign extension for multiplicand and multiplier
always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplier <= {{8{b[7]}}, b};
        multiplicand <= {{8{a[7]}}, a};
        p <= 0;
        ctr <= 0;
        rdy <= 0;
    end else begin
        if (ctr < 16) begin
            // Calculate Booth code for current and next bit
            booth_code = {multiplier[0], multiplier[1]};
            
            case (booth_code)
                2'b01: p = p + multiplicand;   // +M
                2'b10: p = p - multiplicand;   // -M
                2'b11: p = p + (multiplicand << 1); // +2M
                2'b00: p = p - (multiplicand << 1); // -2M
                default: p = p;               // No operation
            endcase
            
            // Shift operations
            multiplicand = multiplicand << 2;
            multiplier = multiplier >> 2;
            ctr = ctr + 2;
        end else if (ctr >= 16) begin
            rdy <= 1;
        end
    end
end

endmodule
