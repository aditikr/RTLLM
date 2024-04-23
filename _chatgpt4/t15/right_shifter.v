module right_shifter (
    input clk,     // Clock signal
    input d,       // Input bit to be shifted into the register
    output reg [7:0] q // 8-bit output register
);

// Initialize the register to 0
initial begin
    q = 8'd0;
end

// Perform the right shifting on the rising edge of the clock
always @(posedge clk) begin
    q <= {d, q[7:1]};  // Concatenate `d` at the MSB and shift `q` right by 1 bit
end

endmodule
