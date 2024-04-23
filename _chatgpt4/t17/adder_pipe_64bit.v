module adder_pipe_64bit(
    input        clk,
    input        rst_n,
    input        i_en,
    input  [63:0] adda,
    input  [63:0] addb,
    output [64:0] result,
    output       o_en
);

    // Internal signal declarations for pipeline stages
    reg [64:0] sum_stage1, sum_stage2, sum_stage3;
    reg        valid_stage1, valid_stage2, valid_stage3;

    // Pipeline Stage 1: Load and compute initial sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1 <= 65'b0;
            valid_stage1 <= 1'b0;
        end else if (i_en) begin
            sum_stage1 <= adda + addb;
            valid_stage1 <= 1'b1;
        end else begin
            valid_stage1 <= 1'b0;
        end
    end

    // Pipeline Stage 2: Propagate sum and validity
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2 <= 65'b0;
            valid_stage2 <= 1'b0;
        end else begin
            sum_stage2 <= sum_stage1;
            valid_stage2 <= valid_stage1;
        end
    end

    // Pipeline Stage 3: Propagate sum and validity to output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3 <= 65'b0;
            valid_stage3 <= 1'b0;
        end else begin
            sum_stage3 <= sum_stage2;
            valid_stage3 <= valid_stage2;
        end
    end

    // Assign outputs
    assign result = sum_stage3;
    assign o_en = valid_stage3;

endmodule
