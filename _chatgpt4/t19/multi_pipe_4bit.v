module multi_pipe_4bit(
    input        clk,
    input        rst_n,
    input  [3:0] mul_a,
    input  [3:0] mul_b,
    output [7:0] mul_out
);

    // Parameters
    localparam size = 4;
    
    // Signals for intermediate sums and final product
    reg [2*size-1:0] partial_products[0:size-1]; 
    reg [2*size-1:0] sum_stage1;
    reg [2*size-1:0] sum_stage2;
    reg [2*size-1:0] final_product;

    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    partial_products[i] <= 0;
                end else begin
                    if (mul_b[i])
                        partial_products[i] <= mul_a << i;
                    else
                        partial_products[i] <= 0;
                end
            end
        end
    endgenerate 

    // Computing sum of partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1 <= 0;
            sum_stage2 <= 0;
            final_product <= 0;
        end else begin
            sum_stage1 <= partial_products[0] + partial_products[1];
            sum_stage2 <= partial_products[2] + partial_products[3];
            final_product <= sum_stage1 + sum_stage2;
        end
    end

    // Assign the output
    assign mul_out = final_product;

endmodule
