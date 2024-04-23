module pe(
    input  logic clk,
    input  logic rst,
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] c
);

    // Declare an internal register to hold the current accumulated value.
    logic [31:0] acc;

    // Update the accumulated register based on the clock or reset signal.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the accumulator
            acc <= 32'b0;
        end else begin
            // Perform multiply-accumulate operation
            acc <= acc + (a * b);
        end
    end

    // Output the current value of the accumulator.
    assign c = acc;

endmodule
