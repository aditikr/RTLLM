module adder_pipe_64bit(
    input  logic clk,
    input  logic rst_n,
    input  logic i_en,
    input  logic [63:0] adda,
    input  logic [63:0] addb,
    output logic [64:0] result,
    output logic o_en
);

    // Pipeline stage registers
    logic [63:0] adda_reg1, addb_reg1;
    logic [64:0] sum_reg2;
    logic i_en_reg1, i_en_reg2;

    // Intermediate signals for addition and carry
    logic [64:0] sum_stage1;

    // First Stage: Register inputs and enable signal
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            adda_reg1 <= 64'b0;
            addb_reg1 <= 64'b0;
            i_en_reg1 <= 1'b0;
        end else begin
            adda_reg1 <= adda;
            addb_reg1 <= addb;
            i_en_reg1 <= i_en;
        end
    end

    // Addition logic for first stage
    always_comb begin
        sum_stage1 = adda_reg1 + addb_reg1;
    end

    // Second Stage: Register the sum and forward enable signal
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            sum_reg2 <= 65'b0;
            i_en_reg2 <= 1'b0;
        end else begin
            sum_reg2 <= sum_stage1;
            i_en_reg2 <= i_en_reg1;
        end
    end

    // Output assignment
    assign result = sum_reg2;
    assign o_en = i_en_reg2;

endmodule
