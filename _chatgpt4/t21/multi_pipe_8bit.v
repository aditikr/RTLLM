module multi_pipe_8bit (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        mul_en_in,
    input  logic [7:0]  mul_a,
    input  logic [7:0]  mul_b,
    output logic        mul_en_out,
    output logic [15:0] mul_out
);

    // Register declarations for pipelining
    logic [7:0]  mul_a_reg, mul_b_reg;                // Registers to store inputs
    logic [15:0] mul_out_reg;                         // Register to store the product output
    logic        mul_en_out_reg;                      // Register to store output enable state

    // Partial product and pipeline stage registers
    logic [15:0] partial_product [7:0];
    logic [15:0] stage1_sum1, stage1_sum2, stage2_sum;

    // Capture input values
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            mul_en_out_reg <= 1'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_out_reg <= mul_en_in;
        end
    end

    // Calculate partial products
    always_comb begin
        for (int i = 0; i < 8; i++) begin
            partial_product[i] = mul_b_reg[i] ? mul_a_reg << i : 16'b0;
        end
    end

    // Pipeline stage 1 - Sum of partial products
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum1 <= 16'b0;
            stage1_sum2 <= 16'b0;
        end else begin
            stage1_sum1 <= partial_product[0] + partial_product[1];
            stage1_sum2 <= partial_product[2] + partial_product[3];
        end
    end

    // Pipeline stage 2 - Final Sum
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= 16'b0;
        end else begin
            stage2_sum <= stage1_sum1 + stage1_sum2 + partial_product[4] + 
                          partial_product[5] + partial_product[6] + partial_product[7];
        end
    end

    // Output result
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
        end else begin
            mul_out_reg <= stage2_sum;
        end
    end
    
    // Assign the output enable and output product
    assign mul_en_out = mul_en_out_reg;
    assign mul_out = mul_out_reg;

endmodule
