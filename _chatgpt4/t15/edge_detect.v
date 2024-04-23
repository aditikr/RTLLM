module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

reg prev_a;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Asynchronous reset: clear the outputs and the state register
        rise <= 0;
        down <= 0;
        prev_a <= 0;
    end else begin
        // Capture the current state of 'a' to detect edges
        rise <= (prev_a == 0) && (a == 1); // Set rise if there was a rising edge
        down <= (prev_a == 1) && (a == 0); // Set down if there was a falling edge
        
        // Update prev_a to the current state of 'a' for the next clock cycle
        prev_a <= a;
    end
end

endmodule
