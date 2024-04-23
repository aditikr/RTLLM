module counter_12(
    input  logic clk,
    input  logic rst_n,
    input  logic valid_count,
    output logic [3:0] out
);

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 4'b0000;    // Reset condition
        end else if (valid_count) begin
            if (out == 4'd11) begin
                out <= 4'b0000;  // Reset the counter after reaching 11
            end else begin
                out <= out + 1;        // Increment the counter
            end
        end
        // When valid_count is 0, keep the counter value unchanged
        // This block does not need an else part as the counter retains its value when valid_count is not set
    end

endmodule
