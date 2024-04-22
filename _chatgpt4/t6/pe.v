
module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);

    // Temporary variable to hold the product of a and b
    wire [63:0] product;

    // Perform multiplication
    assign product = a * b;

    // Process the accumulation or reset based on clock and reset signal
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the accumulator
            c <= 32'b0;
        end else begin
            // Accumulate the result
            c <= c + product[31:0]; // Assuming we only need the lower 32 bits of the product
        end
    end

endmodule
