module JC_counter(
    input clk,        // Clock signal
    input rst_n,      // Active-low reset
    output reg [63:0] Q  // 64-bit output
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition
        Q <= 64'b0;
    end else begin
        // Update the counter based on the current state
        if (Q[0] == 1'b0) begin
            // Increment phase: shift left and set the MSB to 1
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Decrement phase: shift left and set the MSB to 0
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule
