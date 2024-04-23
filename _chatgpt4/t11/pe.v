module pe(
    input clk,          // Clock signal
    input rst,          // Reset signal, active high
    input [31:0] a,     // 32-bit input operand A
    input [31:0] b,     // 32-bit input operand B
    output reg [31:0] c // 32-bit output for accumulated result
);

    // Temporary register to hold the product of a and b
    reg [63:0] product;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the accumulator to 0 when rst is high
            c <= 32'b0;
        end else begin
            // Calculate the product of a and b
            product = a * b;
            // Accumulate the result
            c <= c + product[31:0]; // Assuming lower 32 bits for accumulation
        end
    end
endmodule
