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
    q <= {d, q[7:1]};  // Concatenate d with the 7 LSBs of q, shifted right
end

endmodule
