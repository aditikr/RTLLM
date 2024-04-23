module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Stage 1 Registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg mul_en_out_reg;

    // Stage 2 Registers (multiplication result and carry propagation)
    reg [15:0] product_reg;

    // Pipeline stage 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            mul_en_out_reg <= 1'b0;
        end else begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_out_reg <= mul_en_in;
        end
    end

    // Pipeline stage 2: multiplication logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_reg <= 16'd0;
            mul_en_out <= 1'b0;
        end else begin
            if (mul_en_out_reg) begin
                product_reg <= mul_a_reg * mul_b_reg;  // Simple multiplication
            end
            mul_en_out <= mul_en_out_reg;
        end
    end

    // Output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 16'd0;
        end else begin
            if (mul_en_out) begin
                mul_out <= product_reg;
            end else begin
                mul_out <= 16'd0;
            end
        end
    end

endmodule
