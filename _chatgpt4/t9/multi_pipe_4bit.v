module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);
    parameter size = 4;
    reg [7:0] partial_products [size-1:0];
    reg [7:0] intermediate_sum;

    // Generate Partial Products
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    partial_products[i] <= 0;
                else
                    partial_products[i] <= mul_b[i] ? (mul_a << i) : 0;
            end
        end
    endgenerate

    // Compute Intermediate Sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            intermediate_sum <= 0;
        else begin
            intermediate_sum <= partial_products[0];
            for (i = 1; i < size; i = i + 1) begin
                intermediate_sum <= intermediate_sum + partial_products[i];
            end
        end
    end

    // Output the Final Product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= 0;
        else
            mul_out <= intermediate_sum;
    end

endmodule
