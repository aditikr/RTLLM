module right_shifter(
    input clk,     // Clock signal
    input d,       // Input signal to be shifted into MSB
    output reg [7:0] q  // Output 8-bit shifted register
);

// Initialize the register with 0
initial begin
    q = 8'b0;
end

// Sequential logic for shifting on the rising edge of the clock
always @(posedge clk) begin
    q <= {d, q[7:1]};  // Right shift q and insert d into MSB
end

endmodule
