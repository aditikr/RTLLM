module multi_pipe_4bit (
    input        clk,
    input        rst_n,
    input  [3:0] mul_a,
    input  [3:0] mul_b,
    output [7:0] mul_out
);

    reg [7:0] partial_products[3:0];
    reg [7:0] sum_stage1;
    reg [7:0] sum_stage2;

    // Compute partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            partial_products[0] <= 8'd0;
            partial_products[1] <= 8'd0;
            partial_products[2] <= 8'd0;
            partial_products[3] <= 8'd0;
        end else begin
            partial_products[0] <= mul_b[0] ? {4'b0, mul_a} : 8'd0;
            partial_products[1] <= mul_b[1] ? {3'b0, mul_a, 1'b0} : 8'd0;
            partial_products[2] <= mul_b[2] ? {2'b0, mul_a, 2'b0} : 8'd0;
            partial_products[3] <= mul_b[3] ? {1'b0, mul_a, 3'b0} : 8'd0;
        end
    end

    // First stage of addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1 <= 8'd0;
        end else begin
            sum_stage1 <= partial_products[0] + partial_products[1];
        end
    end

    // Second stage of addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2 <= 8'd0;
        end else begin
            sum_stage2 <= partial_products[2] + partial_products[3];
        end
    end

    // Final output register to store the result
    reg [7:0] result_reg;
    assign mul_out = result_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_reg <= 8'd0;
        end else begin
            result_reg <= sum_stage1 + sum_stage2;
        end
    end

endmodule
