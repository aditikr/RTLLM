module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Internal signals and registers
reg [15:0] multiplier;
reg [16:0] multiplicand;
reg [4:0] ctr;
reg [1:0] next_two_bits;
integer i;

// Initial block to define the initial state
initial begin
    p = 0;
    rdy = 0;
    multiplier = 0;
    multiplicand = 0;
    ctr = 0;
end

// Process starts at positive edge of clk or reset
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize for a new multiplication on reset
        multiplier <= {{8{b[7]}}, b};
        multiplicand <= {1'b0, a, 8'b0};  // 1 extra bit for sign extension
        p <= 0;
        rdy <= 0;
        ctr <= 0;
    end else begin
        if (!rdy) begin
            for(i = 0; i < 2; i = i + 1) begin
                next_two_bits = multiplier[ctr +: 2];  // Get the two bits at position ctr

                case(next_two_bits)
                    2'b01: p = p + (multiplicand >> (ctr >> 1));   // Shifted and add
                    2'b10: p = p - (multiplicand >> (ctr >> 1));   // Shifted and subtract
                    default: p = p;                              // Do nothing for 00 and 11
                endcase

                if (ctr < 14) begin
                    ctr = ctr + 2;  // Increment the counter by 2
                end else begin
                    rdy = 1;  // Set ready after processing all bits
                end
            end
        end
    end
end

endmodule
