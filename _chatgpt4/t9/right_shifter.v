module right_shifter(
    input clk,  // Clock input
    input d,    // Input bit to be shifted into q
    output reg [7:0] q  // 8-bit output register
);

    // Initialize q to 0 at the start
    initial begin
        q = 8'b00000000;
    end

    // Shift logic on the rising edge of the clock
    always @(posedge clk) begin
        q <= {d, q[7:1]};  // Shift right and insert d at the MSB
    end

endmodule
