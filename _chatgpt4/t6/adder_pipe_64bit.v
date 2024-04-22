
module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers for input operands and enable signal
reg [63:0] adda_reg1, adda_reg2;
reg [63:0] addb_reg1, addb_reg2;
reg i_en_reg1, i_en_reg2;

// Pipeline register for intermediate sum
reg [64:0] sum_reg1;

// Combinational logic for addition
wire [64:0] sum_stage1;
assign sum_stage1 = adda_reg1 + addb_reg1;

// Pipeline stage 1: Register inputs and compute first stage sum
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg1 <= 0;
        addb_reg1 <= 0;
        i_en_reg1 <= 0;
    end else begin
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        i_en_reg1 <= i_en;
    end
end

// Pipeline stage 2: Register stage 1 sum and propagate enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg1 <= 0;
        adda_reg2 <= 0;
        addb_reg2 <= 0;
        i_en_reg2 <= 0;
    end else begin
        sum_reg1 <= sum_stage1;
        adda_reg2 <= adda_reg1;
        addb_reg2 <= addb_reg1;
        i_en_reg2 <= i_en_reg1;
    end
end

// Output stage: Register final sum and output enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 0;
        o_en <= 0;
    end else begin
        result <= sum_reg1;
        o_en <= i_en_reg2;
    end
end

endmodule
