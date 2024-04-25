module edge_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic a,
    output logic rise,
    output logic down
);

    // Previous state register for detecting edges
    logic a_prev;

    // Store the previous state of 'a' at each clock edge
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else
            a_prev <= a;
    end

    // Detect rising and falling edges
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (a_prev == 1'b0 && a == 1'b1);    // Set 'rise' on rising edge
            down <= (a_prev == 1'b1 && a == 1'b0);    // Set 'down' on falling edge
        end
    end

endmodule
