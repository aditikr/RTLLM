module radix2_div #(
    parameter DATAWIDTH = 8  // Default data width
)(
    input clk,               // Clock signal
    input rstn,              // Asynchronous active low reset
    input en,                // Enable signal for initiating division    
    input [DATAWIDTH-1:0] dividend,  // 8-bit dividend
    input [DATAWIDTH-1:0] divisor,   // 8-bit divisor
    output reg ready,        // Indicates module readiness
    output reg [DATAWIDTH-1:0] quotient, // Quotient of division
    output reg [DATAWIDTH-1:0] remainder, // Remainder of division
    output reg vld_out        // Valid signal for output
);

// State Encoding
localparam IDLE  = 2'b00,
           SUB   = 2'b01,
           SHIFT = 2'b10,
           DONE  = 2'b11;

// Registers for FSM and data handling
reg [1:0] current_state, next_state;
reg [DATAWIDTH*2-1:0] dividend_e;
reg [DATAWIDTH-1:0] divisor_e, quotient_e, remainder_e;
reg [DATAWIDTH-1:0] count;

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        // Asynchronous reset
        current_state <= IDLE;
        dividend_e <= 0;
        divisor_e <= 0;
        quotient_e <= 0;
        remainder_e <= 0;
        count <= 0;
      	ready <= 1'b1;
      	vld_out <= 1'b0;
    end else begin
        // State transition
        current_state <= next_state;
        
        case (current_state)
            IDLE: begin
                if (en) begin
                    dividend_e <= {dividend, DATAWIDTH'b0};
                    divisor_e <= divisor;
                    quotient_e <= 0;
                    remainder_e <= 0;
                    count <= DATAWIDTH;
                end 
            end
            SUB: begin
                if (dividend_e >= (divisor_e << (count - 1))) begin
                    dividend_e <= dividend_e - (divisor_e << (count - 1));
                    quotient_e <= (quotient_e << 1) + 1;
                end else begin
                    quotient_e <= quotient_e << 1;
                end
            end
            SHIFT: begin
                count <= count - 1;
            end
            DONE: begin
                quotient <= quotient_e;
                remainder <= dividend_e[DATAWIDTH-1:0];
                vld_out <= 1'b1;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: next_state = en ? SUB : IDLE;
        SUB: next_state = SHIFT;
        SHIFT: next_state = (count == 1) ? DONE : SUB;
        DONE: next_state = IDLE;
        default: next_state = IDLE;
    end
end

// Outputs
always @(current_state) begin
    ready = (current_state == IDLE);
end

endmodule
