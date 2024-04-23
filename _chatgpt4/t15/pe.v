module pe (
    input clk,          // Clock signal
    input rst,          // Reset signal (active high)
    input [31:0] a,     // 32-bit input operand A
    input [31:0] b,     // 32-bit input operand B
    output reg [31:0] c // 32-bit output for accumulated result
);

    // Always block triggered on the positive edge of the clock or the positive edge of reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 32'b0;  // Reset the accumulator to 0
        end else begin
            c <= c + (a * b);  // Multiply the inputs and accumulate the result
        end
    end

endmodule
