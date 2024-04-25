module pe(
    input logic clk,
    input logic rst,
    input logic signed [31:0] a,
    input logic signed [31:0] b,
    output logic signed [31:0] c
);

    // Register to hold the accumulated result
    logic signed [31:0] accum;

    // Always block for the state update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            accum <= 32'b0;  // Reset the accumulator to zero on reset signal
        end else begin
            accum <= accum + (a * b);  // Multiply inputs and accumulate
        end
    end

    // Connecting internal register to output port
    assign c = accum;

endmodule
