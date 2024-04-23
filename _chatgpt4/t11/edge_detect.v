module edge_detect(
    input clk,       // Clock signal
    input rst_n,     // Reset signal (active low)
    input a,         // Input signal
    output reg rise, // Output signal indicating a rising edge
    output reg down  // Output signal indicating a falling edge
);

    // Register to store the previous state of 'a'
    reg a_prev;

    // Always block triggered on the positive edge of the clock or negative edge of reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: reset the outputs and the previous state register
            rise <= 0;
            down <= 0;
            a_prev <= 0;
        end else begin
            // Check for a rising edge
            if (a == 1 && a_prev == 0) begin
                rise <= 1;
            end else begin
                rise <= 0;
            end

            // Check for a falling edge
            if (a == 0 && a_prev == 1) begin
                down <= 1;
            end else begin
                down <= 0;
            end

            // Update the previous state of 'a'
            a_prev <= a;
        end
    end

endmodule
