module multi_pipe_4bit(
    input  logic clk,
    input  logic rst_n,
    input  logic [3:0] mul_a,
    input  logic [3:0] mul_b,
    output logic [7:0] mul_out
);

    // Parameters
    parameter size = 4;

    // Signals for storing partial and final products
    logic [7:0] partial_product [0:size-1];
    logic [7:0] sum_1, sum_2;

    // Register for pipeline stages
    logic [7:0] register_1, register_2;

    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < size; i++) begin : PARTIAL_PRODUCT_CALC
            always_comb begin
                if (mul_b[i] == 1)
                    partial_product[i] = mul_a << i;
                else
                    partial_product[i] = 8'd0;
            end
        end
    endgenerate

    // Compute sum of partial products in the first stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            register_1 <= 8'd0;
        end else begin
            sum_1 = partial_product[0] +
                    partial_product[1] +
                    partial_product[2] +
                    partial_product[3];
            register_1 <= sum_1;
        end
    end

    // Pipeline stage 2 to register the output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            register_2 <= 8'd0;
            mul_out <= 8'd0;
        end else begin
            // Passing the result from stage 1 to stage 2
            register_2 <= register_1;
            // Final output
            mul_out <= register_2;
        end
    end

endmodule
