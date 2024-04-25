module multi_pipe_8bit(
    input  logic clk,
    input  logic rst_n,
    input  logic mul_en_in,
    input  logic [7:0] mul_a,
    input  logic [7:0] mul_b,
    output logic mul_en_out,
    output logic [15:0] mul_out
);

    // Registers for inputs to store and pipeline stages
    logic [7:0] mul_a_reg, mul_b_reg;
    logic mul_en_in_d;  // Delayed input enable signal for synchronization
    
    // Register for the product (output)
    logic [15:0] mul_out_reg;

    // Register for output enable
    logic mul_en_out_reg;

    // Partial product calculation using bitwise AND and shifting
    logic [15:0] temp[7:0];  // Array to hold partial products

    // Stages signals
    logic [15:0] stage_1, stage_2, stage_3;

    // Update registers including input buffer registers
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 0;
            mul_b_reg <= 0;
            mul_out_reg <= 0;
            mul_en_in_d <= 0;
            mul_en_out_reg <= 0;
        end else begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_in_d <= mul_en_in;
            if (mul_en_in_d) begin
                mul_en_out_reg <= 1;
                stage_1 <= temp[0] + temp[1];
                stage_2 <= temp[2] + temp[3];
                stage_3 <= temp[4] + temp[5] + temp[6] + temp[7];
            end else begin
                mul_en_out_reg <= 0;
            end
            mul_out_reg <= stage_1 + stage_2 + stage_3;
        end
    end

    // Generate partial products
    always_comb begin
        for (int i = 0; i < 8; i++) begin
            temp[i] = mul_a_reg & {16{mul_b_reg[i]}} << i;
        end
    end

    // Output assignment
    always_comb begin
        if (mul_en_out_reg) begin
            mul_out = mul_out_reg;
        end else begin
            mul_out = 0;
        end
        mul_en_out = mul_en_out_reg;
    end

endmodule
