
module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Internal registers for storing inputs
reg [7:0] mul_a_reg, mul_b_reg;
reg mul_en_in_reg;

// Registers for partial products and their accumulation
reg [15:0] partial_product [7:0];
reg [15:0] sum [6:0];

// Pipeline stages
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        mul_en_in_reg <= 0;
        mul_en_out <= 0;
        mul_out <= 0;
    end else begin
        // Input stage
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_in_reg <= mul_en_in;

        // Compute partial products
        partial_product[0] <= mul_b_reg[0] ? {8'b0, mul_a_reg} : 16'b0;
        partial_product[1] <= mul_b_reg[1] ? {7'b0, mul_a_reg, 1'b0} : 16'b0;
        partial_product[2] <= mul_b_reg[2] ? {6'b0, mul_a_reg, 2'b0} : 16'b0;
        partial_product[3] <= mul_b_reg[3] ? {5'b0, mul_a_reg, 3'b0} : 16'b0;
        partial_product[4] <= mul_b_reg[4] ? {4'b0, mul_a_reg, 4'b0} : 16'b0;
        partial_product[5] <= mul_b_reg[5] ? {3'b0, mul_a_reg, 5'b0} : 16'b0;
        partial_product[6] <= mul_b_reg[6] ? {2'b0, mul_a_reg, 6'b0} : 16'b0;
        partial_product[7] <= mul_b_reg[7] ? {1'b0, mul_a_reg, 7'b0} : 16'b0;

        // Summation stage
        sum[0] <= partial_product[0] + partial_product[1];
        sum[1] <= partial_product[2] + partial_product[3];
        sum[2] <= partial_product[4] + partial_product[5];
        sum[3] <= partial_product[6] + partial_product[7];
        sum[4] <= sum[0] + sum[1];
        sum[5] <= sum[2] + sum[3];
        sum[6] <= sum[4] + sum[5];

        // Output stage
        mul_out <= sum[6];
        mul_en_out <= mul_en_in_reg;
    end
end

endmodule
