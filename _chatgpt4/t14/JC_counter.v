module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'b0;  // Reset the counter
    else begin
        // Check if the LSB is 0 or 1, and then update the counter accordingly
        if (Q[0] == 1'b0) begin
            // If LSB is 0, shift to the right and insert 1 at MSB
            Q <= {1'b1, Q[63:1]};
        end else begin
            // If LSB is 1, shift to the right and insert 0 at MSB
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule
