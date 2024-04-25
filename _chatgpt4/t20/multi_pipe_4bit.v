module multi_pipe_4bit(
    input  logic clk,
    input  logic rst_n,
    input  logic [3:0] mul_a,
    input  logic [3:0] mul_b,
    output logic [7:0] mul_out
);

    // Parameters
    localparam size = 4;
    localparam double_size = size * 2;  // To store the multiplication result
    
    // Internal signals for partial products
    logic [double_size-1:0] partial_products[size:0];
    
    // Pipeline registers
    logic [double_size-1:0] reg_stage1, reg_stage2, final_product;
    
    // Generate partial products based on multiplicand and multiplier bits
    genvar i;
    generate
        for (i = 0; i < size; i++) begin : partial_product_gen
            always_comb begin
                partial_products[i] = mul_b[i] ? (mul_a << i) : 8'd0;
            end
        end
    endgenerate
    
    // Summation in stages
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_stage1 <= 0;
            reg_stage2 <= 0;
            final_product <= 0;
        end else begin
            // First stage sum up
            reg_stage1 <= partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
            // Move first stage to second stage
            reg_stage2 <= reg_stage1;
            // Sum up second stage
            final_product <= reg_stage2;
        end
    end
    
    // Assign final product to output
    assign mul_out = final_product;
    
endmodule
