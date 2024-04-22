
module edge_detect(
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    // Register to hold the previous value of 'a'
    reg a_prev;

    // Always block triggered on the positive edge of the clock and negative edge of reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: reset the outputs and the previous value register
            rise <= 0;
            down <= 0;
            a_prev <= 0;
        end else begin
            // Check for rising edge
            if (a == 1 && a_prev == 0) begin
                rise <= 1;
            end else begin
                rise <= 0;
            end

            // Check for falling edge
            if (a == 0 && a_prev == 1) begin
                down <= 1;
            end else begin
                down <= 0;
            end

            // Update the previous value of 'a'
            a_prev <= a;
        end
    end

endmodule
