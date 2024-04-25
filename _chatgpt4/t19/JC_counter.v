module JC_counter(
    input  logic clk,
    input  logic rst_n,
    output logic [63:0] Q
);

    // Johnson Counter Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 64'd0; // Reset condition
        end else begin
            // The twist in the counter
            Q[63] <= ~Q[0];
            Q[62:0] <= Q[63:1]; // Shift operation
        end
    end
    
endmodule
