module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;
reg [7:0] partial_products[0:size-1];
reg [7:0] intermediate_sum;

// Generate partial products
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < size; i = i + 1) begin
            partial_products[i] <= 0;
        end
        intermediate_sum <= 0;
        mul_out <= 0;
    end else begin
        for (i = 0; i < size; i = i + 1) begin
            if (mul_b[i])
                partial_products[i] <= mul_a << i;
            else
                partial_products[i] <= 0;
        end
    end
end

// Calculate intermediate sum of partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        intermediate_sum <= 0;
    end else begin
        intermediate_sum <= partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
    end
end

// Calculate final product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= intermediate_sum;
    end
end

endmodule
