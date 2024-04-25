module adder_pipe_64bit(
    input logic clk,
    input logic rst_n,
    input logic i_en,
    input logic [63:0] adda,
    input logic [63:0] addb,
    output logic [64:0] result,
    output logic o_en
);

    // Define pipeline stages for operands, sum, and carry out
    logic [63:0] stage1_adda, stage1_addb;
    logic [64:0] stage2_sum;
    logic stage1_en, stage2_en;

    // Register the input operands at stage 1
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_adda <= 0;
            stage1_addb <= 0;
            stage1_en <= 0;
        end else if (i_en) begin
            stage1_adda <= adda;
            stage1_addb <= addb;
            stage1_en <= 1;
        end else begin
            stage1_en <= 0;
        end
    end

    // Compute the sum in the second stage
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= 0;
            stage2_en <= 0;
        end else if (stage1_en) begin
            // Adding the two 64-bit numbers with carry
            stage2_sum <= stage1_adda + stage1_addb;
            stage2_en <= stage1_en;
        end else begin
            stage2_en <= 0;
        end
    end

    // Update the final result and output enable signal
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 0;
            o_en <= 0;
        end else if (stage2_en) begin
            result <= stage2_sum;
            o_en <= 1;
        end else begin
            o_en <= 0;
        end
    end

endmodule
