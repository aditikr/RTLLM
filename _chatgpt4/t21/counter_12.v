module counter_12(
    input logic rst_n,
    input logic clk,
    input logic valid_count,
    output reg [3:0] out
);

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset logic
            out <= 4'b0000;
        end else if (valid_count) begin
            // Counting based on the valid_count signal
            if (out == 4'd11) begin
                // Wrap around when maximum count is reached
                out <= 4'b0000;
            end else begin
                // Increment the counter
                out <= out + 1;
            end
        end
    end

endmodule
