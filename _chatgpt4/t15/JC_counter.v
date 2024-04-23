module JC_counter(
    input clk,            // Clock input
    input rst_n,          // Active-low reset
    output reg [63:0] Q   // 64-bit output register
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition: Set Q to all zeros
        Q <= 64'b0;
    end else begin
        // Check the least significant bit to determine the next state of the counter
        if (Q[0] == 1'b0) begin
            // If LSB is 0, shift right and set MSB to 1
            Q <= {1'b1, Q[63:1]};
        end else begin
            // If LSB is 1, shift right and set MSB to 0
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule
