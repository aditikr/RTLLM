module multi_pipe_8bit(
    input  logic clk,
    input  logic rst_n,
    input  logic mul_en_in,
    input  logic [7:0] mul_a,
    input  logic [7:0] mul_b,
    output logic mul_en_out,
    output logic [15:0] mul_out
);

    // Registers to hold the inputs during the pipeline stages
    logic mul_en_reg;
    logic [7:0] mul_a_reg, mul_b_reg;

    // Pipeline stage register for multiplication result
    logic [15:0] product_reg;

    // This register will pass the enable signal through the pipeline
    logic mul_en_pipeline_reg;

    // Input register stage
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            mul_en_reg <= 1'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_reg <= mul_en_in;
        end
    end

    // Combinational logic to calculate the product
    logic [15:0] mul_stage_product;
    always_comb begin
        mul_stage_product = mul_a_reg * mul_b_reg; // Simple multiplication for the example
    end

    // Product register stage
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_reg <= 16'b0;
            mul_en_pipeline_reg <= 1'b0;
        end else begin
            product_reg <= mul_stage_product;
            mul_en_pipeline_reg <= mul_en_reg;
        end
    end

    // Output assignment
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 16'b0;
            mul_en_out <= 1'b0;
        end else begin
            mul_out <= product_reg;
            mul_en_out <= mul_en_pipeline_reg;
        end
    end

endmodule
