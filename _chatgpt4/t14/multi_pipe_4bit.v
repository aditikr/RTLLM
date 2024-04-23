module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);
    parameter size = 4;
    
    // Intermediate registers for partial products and sum
    reg [7:0] partial_products[0:size-1];
    reg [7:0] stage1_sum, stage2_sum;

    // Generate partial products
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all partial products and intermediate sums
            for (i = 0; i < size; i = i + 1) begin
                partial_products[i] <= 0;
            end
            stage1_sum <= 0;
            stage2_sum <= 0;
            mul_out <= 0;
        end else begin
            for (i = 0; i < size; i = i + 1) begin
                if (mul_b[i])
                    partial_products[i] <= (mul_a << i);
                else
                    partial_products[i] <= 0;
            end
            // Calculate sum of partial products in stages
            stage1_sum <= partial_products[0] + partial_products[1];
            stage2_sum <= partial_products[2] + partial_products[3];
        end
    end

    // Sum intermediate sums to calculate final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= stage1_sum + stage2_sum;
        end
    end

endmodule
