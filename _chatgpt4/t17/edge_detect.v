module edge_detect(
    input logic clk,
    input logic rst_n,
    input logic a,
    output logic rise,
    output logic down
);

    // Declare a register to hold the previous state of 'a'
    logic a_prev;

    // Process block for detecting edges
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Resetting the values when reset is active low
            a_prev <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Checking for edges
            rise <= (a == 1'b1 && a_prev == 1'b0);  // Detect rising edge
            down <= (a == 1'b0 && a_prev == 1'b1);  // Detect falling edge

            // Update the previous state
            a_prev <= a;
        end
    end

endmodule
