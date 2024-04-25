module edge_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic a,
    output logic rise,
    output logic down
);

    // Previous value of 'a' to detect edges
    logic a_prev;

    // Register to store the previous state of 'a'
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 0;
        end else begin
            a_prev <= a;
        end
    end

    // Detect rising and falling edges
    always_ff @(posedge clk) begin
        if (rst_n) begin
            // Check for rising edge
            rise = (a_prev == 1'b0 && a == 1'b1) ? 1'b1 : 1'b0;
            // Check for falling edge
            down = (a_prev == 1'b1 && a == 1'b0) ? 1'b1 : 1'b0;
        end else begin
            rise = 1'b0;
            down = 1'b0;
        end
    end

endmodule
