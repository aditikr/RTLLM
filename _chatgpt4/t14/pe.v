module pe(
    input clk,        // Clock signal
    input rst,        // Reset signal
    input [31:0] a,   // 32-bit input operand A
    input [31:0] b,   // 32-bit input operand B
    output reg [31:0] c  // 32-bit output accumulated result
);

    // Intermediate variable to hold the product of a and b
    wire [63:0] product;
    
    // Perform multiplication
    assign product = a * b;

    // Process the clock and reset signals
    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            // Reset the accumulator to 0
            c <= 32'b0;
        end else begin
            // Accumulate the product into the register c
            c <= c + product[31:0];  // Using only lower 32 bits to avoid overflow issues in this example
        end
    end
endmodule
