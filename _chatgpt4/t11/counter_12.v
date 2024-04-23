module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

    // Counter operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset the counter to 0 when reset is active low
            out <= 4'b0000;
        end
        else if (valid_count) begin
            // Increment the counter if valid_count is high
            if (out == 4'd11) begin
                // Reset to 0 if the counter reaches 11
                out <= 4'b0000;
            end
            else begin
                // Increment the counter
                out <= out + 1;
            end
        end
        // If valid_count is 0, do nothing (counter holds its value)
    end

endmodule
