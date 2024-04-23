module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Internal registers for pipeline stages
reg [7:0] mul_a_reg, mul_b_reg;
reg [15:0] partial_products[7:0];
reg [15:0] sum_stage1, sum_stage2, sum_stage3;
reg mul_en_reg;

// Pipeline stage 1: Register inputs and enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        mul_en_reg <= 0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_reg <= mul_en_in;
    end
end

// Pipeline stage 2: Generate partial products
integer i;
always @(posedge clk) begin
    for (i = 0; i < 8; i++) begin
        partial_products[i] <= mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
end

// Pipeline stage 3: Sum partial products
always @(posedge clk) begin
    sum_stage1 <= partial_products[0] + partial_products[1];
    sum_stage2 <= partial_products[2] + partial_products[3];
    sum_stage3 <= partial_products[4] + partial_products[5];
end

// Pipeline stage 4: Final sum and output enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
        mul_en_out <= 0;
    end else begin
        mul_out <= sum_stage1 + sum_stage2 + sum_stage3 + partial_products[6] + partial_products[7];
        mul_en_out <= mul_en_reg;
    end
end

endmodule
