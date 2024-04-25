module pe (
    input logic clk,
    input logic rst,
    input logic [31:0] a,
    input logic [31:0] b,
    output logic [31:0] c
);

    // Declare the internal register to hold the accumulated result
    logic [31:0] acc;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the accumulator to 0 when the reset signal is high
            acc <= 32'b0;
        end else begin
            // Perform the multiplication of a and b, and add the result to the accumulator
            acc <= acc + (a * b);
        end

        // The output c always reflects the content of the accumulator
        c = acc;
    end

endmodule
