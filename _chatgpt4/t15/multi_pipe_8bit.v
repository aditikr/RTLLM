module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

// Intermediate registers for pipelining stages
reg [7:0] mul_a_reg, mul_b_reg; // Register for inputs
reg [15:0] product_reg;        // Register for intermediate products
reg mul_en_reg;                 // Register for enable signal

// Output registers
reg [15:0] mul_out_reg;
reg mul_en_out_reg;

// Pipeline stage 1: Register inputs and enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        mul_en_reg <= 0;
    end
    else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_reg <= mul_en_in;
    end
end

// Pipeline stage 2: Perform multiplication
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        product_reg <= 0;
        mul_en_out_reg <= 0;
    end
    else if (mul_en_reg) begin
        product_reg <= mul_a_reg * mul_b_reg;
        mul_en_out_reg <= mul_en_reg;
    end
end

// Pipeline stage 3: Register the output product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 0;
    end else begin
        mul_out_reg <= product_reg;
    end
end

// Assign outputs
assign mul_out = mul_out_reg;
assign mul_en_out = mul_en_out_reg;

endmodule
