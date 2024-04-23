module JC_counter(
    input clk,        // Clock signal
    input rst_n,      // Active-low reset signal
    output reg [63:0] Q  // 64-bit output representing the current count value
);

// Johnson counter behavior
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition: Set Q to 0
        Q <= 64'b0;
    end else begin
        // Update counter based on the value of the least significant bit (Q[0])
        if (Q[0] == 1'b0) begin
            // If Q[0] is 0, shift right and insert 1 at MSB
            Q <= {1'b1, Q[63:1]};
        end else begin
            // If Q[0] is 1, shift right and insert 0 at MSB
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule
