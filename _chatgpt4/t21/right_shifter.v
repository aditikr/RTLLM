module right_shifter(
    input  logic clk,
    input  logic d,
    output logic [7:0] q
);

    // Initial reset of the register
    initial q = 0;

    // Right shift operation
    always @(posedge clk) begin
        q <= {d, q[7:1]}; // Shift right by incorporating new data bit 'd' into MSB
    end

endmodule
