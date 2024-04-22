module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);

    // Always block triggered on the positive edge of the clock or reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the accumulator to zero when reset signal is high
            c <= 32'b0;
        end else begin
            // Perform multiplication of a and b, and add the result to the accumulator
            c <= c + (a * b);
        end
    end

endmodule
