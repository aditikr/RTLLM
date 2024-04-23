module multi_16bit (
    input logic clk,
    input logic rst_n,
    input logic start,
    input logic [15:0] ain,
    input logic [15:0] bin,
    output logic [31:0] yout,
    output logic done
);

    // Internal states for the operation
    logic [31:0] product_reg;
    logic [15:0] multiplicand_reg, multiplier_reg;
    logic [4:0] count;  // Enough to count up to 16

    // Sequential Logic - Registers handling
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_reg <= 32'b0;
            multiplicand_reg <= 16'b0;
            multiplier_reg <= 16'b0;
            count <= 5'b0;
        end else begin
            if (start) begin
                if (count == 5'b0) begin
                    // Initialize on the start of multiplication
                    product_reg <= 32'b0;
                    multiplicand_reg <= ain;
                    multiplier_reg <= bin;
                    count <= count + 1'b1;
                end else if (count <= 16) begin
                    // Shift and accumulate
                    if (multiplicand_reg[0]) begin
                        product_reg <= product_reg + ({16'b0, multiplier_reg} << (count - 1));
                    end
                    // Shift multiplicand right for next cycle
                    multiplicand_reg <= multiplicand_reg >> 1;
                    count <= count + 1'b1;
                end
            end else begin
                count <= 5'b0;  // Reset count if not starting
            end
        end
    end

    // Completion flag logic and output assignment
    assign done = (count == 17);  // Indicates operation is complete
    assign yout = product_reg;  // Product output

endmodule
