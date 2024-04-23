module multi_pipe_8bit(
    input  logic clk,
    input  logic rst_n,
    input  logic mul_en_in,
    input  logic [7:0] mul_a,
    input  logic [7:0] mul_b,
    output logic mul_en_out,
    output logic [15:0] mul_out
);

    // Internal registers for storing inputs and outputs of the multiplication
    logic mul_en_reg;
    logic [7:0] mul_a_reg, mul_b_reg;
    logic [15:0] mul_out_reg;

    // Register the input enable signal and input data
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_reg <= 1'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_en_reg <= mul_en_in;
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Output enable registration for the next pipeline stage
    reg mul_en_out_reg;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out_reg <= 1'b0;
        end else begin
            mul_en_out_reg <= mul_en_reg;
        end
    end

    // Assign output enable to the registered enable value
    assign mul_en_out = mul_en_out_reg;

    // Pipeline stage for multiplying
    wire [15:0] partial_products [7:0];

    // Generate the partial_products based on mul_a and mul_b
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin : gen_partial_products
            assign partial_products[i] = (mul_b_reg[i]) ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Summing the partial products in a single stage
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
        end else if (mul_en_reg) begin
            mul_out_reg <= partial_products[0] + partial_products[1] + partial_products[2] + 
                           partial_products[3] + partial_products[4] + partial_products[5] +
                           partial_products[6] + partial_products[7];
        end
    end
    
    // Output the final product
    assign mul_out = (mul_en_out_reg) ? mul_out_reg : 16'b0;

endmodule
