
module JC_counter(
    input clk,          // Clock signal
    input rst_n,        // Active-low reset
    output reg [63:0] Q // 64-bit output
);

// Sequential logic for the Johnson counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition: Set Q to 0
        Q <= 64'b0;
    end else begin
        // Normal operation: Update Q based on the value of Q[0]
        if (Q[0] == 1'b0) begin
            // If Q[0] is 0, shift left and insert 1 at MSB
            Q <= {1'b1, Q[63:1]};
        end else begin
            // If Q[0] is 1, shift left and insert 0 at MSB
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule
