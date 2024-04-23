module edge_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic a,
    output logic rise,
    output logic down
);

    // Previous state register to hold previous clock cycle value of 'a'
    logic a_prev;

    // State register for previous value storage
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
        end else begin
            a_prev <= a;
        end
    end

    // Logic to set rise and fall indicators
    always_comb begin
        if (!rst_n) begin
            rise = 1'b0;
            down = 1'b0;
        end else begin
            // Check for a rising edge
            rise = (a_prev == 1'b0 && a == 1'b1) ? 1'b1 : 1'b0;
            // Check for a falling edge
            down = (a_prev == 1'b1 && a == 1'b0) ? 1'b1 : 1'b0;
        end
    end

endmodule
