
module adder_pipe_64bit (
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] sum[3:0];
reg [3:0] carry[3:0];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < 4; i = i + 1) begin
            sum[i] <= 64'b0;
            carry[i] <= 4'b0;
        end
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        if (i_en) begin
            sum[0] <= adda + addb;
            carry[0] <= {1'b0, sum[0][63]};
            sum[1] <= sum[0] + {64'b0, carry[0]};
            carry[1] <= {1'b0, sum[1][127]};
            sum[2] <= sum[1] + {64'b0, carry[1]};
            carry[2] <= {1'b0, sum[2][191]};
            sum[3] <= sum[2] + {64'b0, carry[2]};
            carry[3] <= {1'b0, sum[3][255]};
            result <= {carry[3], sum[3]};
            o_en <= 1'b1;
        end else begin
            result <= 65'b0;
            o_en <= 1'b0;
        end
    end
end

endmodule
