module multi_pipe_4bit (
    input logic clk,
    input logic rst_n,
    input logic [3:0] mul_a,
    input logic [3:0] mul_b,
    output logic [7:0] mul_out
);

    parameter size = 4;
    
    // Intermediate partial products
    logic [size*2-1:0] partial_products[size-1:0];

    // Registers to store intermediate sum values
    logic [size*2-1:0] intermediate_sums[size-1:0];

    // Calculate each partial product
    genvar i;
    generate
        for (i = 0; i < size; i++) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a << i) : 0;
        end
    endgenerate

    // Intermediate sum computation with pipeline registers
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            intermediate_sums[0] <= 0;
        end else begin
            intermediate_sums[0] <= partial_products[0];
        end
    end

    generate
        for (i = 1; i < size; i++) begin : gen_intermediate_sums
            always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    intermediate_sums[i] <= 0;
                end else begin
                    intermediate_sums[i] <= intermediate_sums[i-1] + partial_products[i];
                end
            end
        end
    endgenerate

    // Final product calculation
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= intermediate_sums[size-1];
        end
    end

endmodule
