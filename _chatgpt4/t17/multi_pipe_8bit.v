module multi_pipe_8bit (
    input logic         clk,
    input logic         rst_n,
    input logic         mul_en_in,
    input logic [7:0]   mul_a,
    input logic [7:0]   mul_b,
    output logic        mul_en_out,
    output logic [15:0] mul_out
);

    // Pipeline stages
    logic               mul_en_stage1, mul_en_stage2, mul_en_stage3;
    logic [7:0]         mul_a_stage1, mul_b_stage1;
    logic [7:0]         mul_a_stage2, mul_b_stage2;
    logic [15:0]        partial_product_stage2, sum_stage3;

    // Registers to hold the pipeline stages
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            mul_en_stage1 <= 0;
            mul_en_stage2 <= 0;
            mul_en_stage3 <= 0;
            mul_a_stage1 <= 0;
            mul_b_stage1 <= 0;
            mul_a_stage2 <= 0;
            mul_b_stage2 <= 0;
            partial_product_stage2 <= 0;
            sum_stage3 <= 0;
        end else begin
            // Stage 1
            mul_en_stage1 <= mul_en_in;
            mul_a_stage1 <= mul_a;
            mul_b_stage1 <= mul_b;
            
            // Stage 2
            mul_en_stage2 <= mul_en_stage1;
            mul_a_stage2 <= mul_a_stage1;
            mul_b_stage2 <= mul_b_stage1;
            partial_product_stage2 <= mul_a_stage2 * mul_b_stage2;

            // Stage 3
            mul_en_stage3 <= mul_en_stage2;
            sum_stage3 <= partial_product_stage2;
        end
    end

    // Output logic
    assign mul_out = (mul_en_stage3 ? sum_stage3 : 16'd0);
    assign mul_en_out = mul_en_stage3;

endmodule
