module right_shifter(
    input  logic clk,
    input  logic d,
    output logic [7:0] q
);

    // Register to hold the shifted values
    reg [7:0] q_reg;

    // Output assignment
    assign q = q_reg;

    // Initialize q_reg to 0
    initial begin
        q_reg = 8'b00000000;
    end

    // Right shift logic on positive clock edge
    always @(posedge clk) begin
        q_reg <= {d, q_reg[7:1]};  // Insert new bit d at MSB, shift right
    end

endmodule
