module multi_pipe_8bit(
    input  logic clk,
    input  logic rst_n,
    input  logic mul_en_in,
    input  logic [7:0] mul_a,
    input  logic [7:0] mul_b,
    output logic mul_en_out,
    output logic [15:0] mul_out
);

    // Pipeline stage signals
    logic mul_en_pipe1, mul_en_pipe2;
    logic [7:0] mul_a_reg, mul_b_reg;
    logic [15:0] partial_product [7:0];
    logic [15:0] sum_stage1, sum_stage2, sum_stage3;

    // Input buffering
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 0;
            mul_b_reg <= 0;
            mul_en_pipe1 <= 0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_pipe1 <= mul_en_in;
        end
    end

    // Partial product generation
    always_comb begin
        for (int i = 0; i < 8; i++) begin
            partial_product[i] = (mul_b_reg[i] ? mul_a_reg : 8'h0) << i;
        end
    end

    // Sum partial products with reduction stage
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1 <= 0;
            sum_stage2 <= 0;
            sum_stage3 <= 0;
            mul_en_pipe2 <= 0;
        end else begin
            sum_stage1 <= partial_product[0] + partial_product[1] + partial_product[2] + partial_product[3];
            sum_stage2 <= partial_product[4] + partial_product[5] + partial_product[6] + partial_product[7];
            mul_en_pipe2 <= mul_en_pipe1;
        end
    end

    // Final summing stage
    logic [15:0] mul_out_reg;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 0;
            mul_en_out <= 0;
        end else begin
            sum_stage3 <= sum_stage1 + sum_stage2;
            mul_out_reg <= sum_stage3;
            mul_en_out <= mul_en_pipe2;
        end
    end

    // Output assignment
    assign mul_out = mul_out_reg;
endmodule
