module counter_12(
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

    // Reset condition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 4'b0000;
        end
        else if (valid_count) begin
            if (out == 4'd11) begin
                // Reset the counter when the maximum count is reached
                out <= 4'b0000;
            end else begin
                // Increment the counter
                out <= out + 1;
            end
        end
        // If valid_count is not active (is 0), the counter value is held (not changed).
    end
endmodule
