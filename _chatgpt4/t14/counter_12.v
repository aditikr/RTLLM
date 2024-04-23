module counter_12 (
    input wire clk,            // Clock input
    input wire rst_n,          // Active low reset
    input wire valid_count,    // Enable counting
    output reg [3:0] out       // 4-bit count output
);

    // Initialize counter and set default value
    initial out = 4'b0000;

    // Synchronous reset and count operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset the counter to 0 when reset signal (rst_n) is active low
            out <= 4'b0000;
        end else if (valid_count) begin
            // Increment the counter when valid_count is high
            if (out == 4'd11) begin
                // Wrap the counter to 0 when it reaches 4'd11
                out <= 4'b0000;
            end else begin
                // Normal increment by 1
                out <= out + 1'b1;
            end
        end
        // If valid_count is 0, do nothing (retain previous state)
    end

endmodule
