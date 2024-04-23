module adder_pipe_64bit(
    input        clk,
    input        rst_n,
    input        i_en,
    input  [63:0] adda,
    input  [63:0] addb,
    output [64:0] result,
    output       o_en
);

    // Pipeline registers for operands, carry and output enable
    reg [63:0] reg_adda_stage1, reg_addb_stage1;
    reg [64:0] reg_sum_stage2;
    reg        reg_i_en_stage1, reg_o_en_stage2;

    // Register the result and o_en
    reg [64:0] result_reg;
    reg        o_en_reg;
    
    // Assign output
    assign result = result_reg;
    assign o_en = o_en_reg;

    // Pipeline stage 1: Register inputs and i_en
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_adda_stage1 <= 64'd0;
            reg_addb_stage1 <= 64'd0;
            reg_i_en_stage1 <= 1'b0;
        end else begin
            if (i_en) begin
                reg_adda_stage1 <= adda;
                reg_addb_stage1 <= addb;
                reg_i_en_stage1 <= i_en;
            end
        end
    end

    // Pipeline stage 2: Perform Addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_sum_stage2 <= 65'd0;
            reg_o_en_stage2 <= 1'b0;
        end else begin
            if (reg_i_en_stage1) begin
                reg_sum_stage2 <= reg_adda_stage1 + reg_addb_stage1;
                reg_o_en_stage2 <= reg_i_en_stage1;
            end
        end
    end

    // Output stage: Register result and o_en
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_reg <= 65'd0;
            o_en_reg <= 1'b0;
        end else begin
            result_reg <= reg_sum_stage2;
            o_en_reg <= reg_o_en_stage2;
        end
    end
endmodule
