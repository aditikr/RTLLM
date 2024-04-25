module adder_pipe_64bit(
    input logic        clk,
    input logic        rst_n,
    input logic        i_en,
    input logic [63:0] adda,
    input logic [63:0] addb,
    output logic [64:0] result,
    output logic       o_en
);

    // Define pipeline registers for operands, sum, and enable signal
    logic [63:0] adda_reg1, adda_reg2;
    logic [63:0] addb_reg1, addb_reg2;
    logic [64:0] sum_reg1, sum_reg2;
    logic en_reg1, en_reg2, en_reg3;

    // First pipeline stage: Capture inputs and begin addition
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg1 <= 0;
            addb_reg1 <= 0;
            en_reg1 <= 0;
        end else if (i_en) begin
            adda_reg1 <= adda;
            addb_reg1 <= addb;
            en_reg1 <= i_en;
        end
    end

    // Second pipeline stage: Compute the initial addition with a ripple carry adder method
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg1 <= 0;
            adda_reg2 <= 0;
            addb_reg2 <= 0;
            en_reg2 <= 0;
        end else if (en_reg1) begin
            {sum_reg1[64], sum_reg1[63:0]} = adda_reg1 + addb_reg1;
            adda_reg2 <= adda_reg1;
            addb_reg2 <= addb_reg1;
            en_reg2 <= en_reg1;
        end
    end

    // Third pipeline stage: Confirm the result and manage final output readiness
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg2 <= 0;
            en_reg3 <= 0;
        end else if (en_reg2) begin
            sum_reg2 <= sum_reg1;
            en_reg3 <= en_reg2;
        end
    end

    // Capture final result and signal output readiness
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 0;
            o_en <= 0;
        end else begin
            result <= sum_reg2;
            o_en <= en_reg3;
        end
    end

endmodule
