module multi_pipe_4bit(
    input clk, 
    input rst_n,
    input [3:0] mul_a, 
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Intermediate product storage with zero extension
reg [7:0] partial_prod [size-1:0];
reg [7:0] sum_stage1, sum_stage2; // Pipelined summation registers

// Generate partial products
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset partial products and pipeline registers
        for (i = 0; i < size; i++)
            partial_prod[i] <= 0;
        sum_stage1 <= 0;
        sum_stage2 <= 0;
        mul_out <= 0;
    end
    else begin
        // Compute the partial products
        for (i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) 
                partial_prod[i] <= (mul_a << i);  // Shift left by i positions
            else 
                partial_prod[i] <= 8'd0;
        end

        // Pipeline stage 1: Add partial products
        sum_stage1 <= partial_prod[0] + partial_prod[1] + partial_prod[2] + partial_prod[3];
        
        // Pipeline stage 2: Update the intermediate sum to the output
        sum_stage2 <= sum_stage1;
        
        // Set the output
        mul_out <= sum_stage2;
    end
end

endmodule
