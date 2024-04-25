module multi_booth_8bit(
    input         clk,
    input         reset,
    input  [7:0]  a,
    input  [7:0]  b,
    output [15:0] p,
    output        rdy
);

// Internal signals
reg [15:0] p_reg;
reg [15:0] m_reg;
reg [15:0] q_reg; // With additional bit for algorithmic procedure
reg [4:0]  ctr;
reg        rdy_reg;

assign p = p_reg;
assign rdy = rdy_reg;

always @(posedge clk or posedge reset)
begin
    if (reset)
    begin
        // Reset internal states
        p_reg <= 16'd0;
        q_reg <= {1'b0, b, 1'b0};
        m_reg <= {{8{a[7]}}, a}; // Sign-extended multiplicand
        ctr <= 5'd0;
        rdy_reg <= 0;
    end
    else if (ctr < 16)
    begin
        // Implementing the Booth encoding based on 2 bits each time & shifting
        case (q_reg[1:0])  // only need the last 2 bits of the Q register for Booth algorithm.
            2'b01: p_reg <= p_reg + m_reg;
            2'b10: p_reg <= p_reg - m_reg;
            default: p_reg <= p_reg; // 2'b00 and 2'b11 cases: no addition or subtraction.
        endcase

        // Right shift (arithmetical) the results
        p_reg <= {p_reg[15], p_reg[15:1]}; // Replicate the MSB to preserve sign
        q_reg <= {p_reg[0], q_reg[15:1]};
        
        // Incrementing the counter
        ctr <= ctr + 1;
    end
    else if (ctr == 16)
    begin
        rdy_reg <= 1; // Indicate that multiplication is ready
    end
end

endmodule
