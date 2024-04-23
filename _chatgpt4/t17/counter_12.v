module counter_12 (
    input  logic clk,             // Clock signal
    input  logic rst_n,           // Reset signal (active low)
    input  logic valid_count,     // Enable signal for counting
    output logic [3:0] out        // 4-bit output for the count
);

    // Register declaration for the counter
    logic [3:0] count_reg;

    // Always block for synchronous reset and counting
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_reg <= 4'b0000;  // Resetting the count to 0 when reset is active
        end else if (valid_count) begin
            if (count_reg == 4'd11) begin
                count_reg <= 4'b0000;  // Wrap around when max count (11) is reached
            end else begin
                count_reg <= count_reg + 1;  // Increment the counter
            end
        end
        // When valid_count is 0, do nothing (counter remains unchanged)
    end

    // Output logic - directly mapping count_reg to the output
    always_comb begin
        out = count_reg;
    end

endmodule
