module adder_pipe_64bit(
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Internal signals to hold intermediate results and enable signals
reg [63:0] adda_stage1, addb_stage1;
reg [64:0] sum_stage1;
reg [64:0] sum_stage2;
reg i_en_stage1, i_en_stage2;

// Pipeline Stage 1: Input latching and simple addition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_stage1 <= 0;
        addb_stage1 <= 0;
        i_en_stage1 <= 0;
    end else begin
        if (i_en) begin
            adda_stage1 <= adda;
            addb_stage1 <= addb;
            i_en_stage1 <= i_en;
        end else begin
            i_en_stage1 <= 0;
        end
    end
end

// Compute sum in Stage 1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage1 <= 0;
    end else begin
        sum_stage1 <= adda_stage1 + addb_stage1;
    end
end

// Pipeline Stage 2: Result propagating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2 <= 0;
        i_en_stage2 <= 0;
    end else begin
        sum_stage2 <= sum_stage1;
        i_en_stage2 <= i_en_stage1;
    end
end

// Output result assignment
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 0;
        o_en <= 0;
    end else begin
        result <= sum_stage2;
        o_en <= i_en_stage2;
    end
end

endmodule
