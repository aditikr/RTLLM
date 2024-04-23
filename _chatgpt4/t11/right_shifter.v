module right_shifter(
    input clk,  // Clock signal
    input d,    // Input data bit to be shifted into q
    output reg [7:0] q  // 8-bit output register
);

// Initialize the register q to 0
initial begin
    q = 8'b00000000;
end

// On each rising edge of the clock, shift q right and insert d at MSB
always @(posedge clk) begin
    q <= {d, q[7:1]};  // Concatenate d with the 7 MSBs of q shifted right
end

endmodule
module right_shifter(
    input clk,
    input rst_n,  // Active low reset
    input d,
    output reg [7:0] q
);

// Reset or shift logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 8'b00000000;  // Clear q on reset
    else
        q <= {d, q[7:1]};  // Shift right and insert d at MSB
end

endmodule
