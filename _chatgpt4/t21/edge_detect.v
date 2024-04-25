module edge_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic a,
    output logic rise,
    output logic down
);

    // Registers to hold previous state of 'a'
    logic a_prev;

    // Process block to detect edges
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;    // Initialize on reset
            rise <= 1'b0;      // No rise on reset
            down <= 1'b0;      // No down on reset
        end else begin
            // Detect rising edge
            if (a == 1'b1 && a_prev == 1'b0) begin
                rise <= 1'b1;  // Set rise signal
                down <= 1'b0;  // Clear down signal
            end
            // Detect falling edge
            else if (a == 1'b0 && a_prev == 1'b1) begin
                down <= 1'b1;  // Set down signal
                rise <= 1'b0;  // Clear rise signal
            end
            else begin
                // Reset outputs if no edge
                rise <= 1'b0;
                down <= 1'b0;
            end

            // Update previous state of 'a'
            a_prev <= a;
        end
    end
endmodule
