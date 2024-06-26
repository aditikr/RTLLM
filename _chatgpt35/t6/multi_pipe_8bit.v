
module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [7:0] temp [7:0];
reg [15:0] sum [7:0];
reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_out <= 1'b0;
        mul_out_reg <= 16'b0;
        for (int i = 0; i < 8; i = i + 1) begin
            temp[i] <= 8'b0;
            sum[i] <= 16'b0;
        end
    end else begin
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_out <= 1'b1;
            for (int i = 0; i < 8; i = i + 1) begin
                temp[i] <= mul_a_reg & (mul_b_reg[i] ? 8'b1 : 8'b0);
            end
            for (int i = 0; i < 8; i = i + 1) begin
                sum[i] <= {sum[i-1], temp[i]} + sum[i];
            end
            mul_out_reg <= sum[7];
        end else begin
            mul_en_out <= 1'b0;
            mul_out_reg <= 16'b0;
        end
    end
end

assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule
