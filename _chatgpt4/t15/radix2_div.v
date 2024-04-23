module radix2_div #(
    parameter DATAWIDTH = 8
) (
    input clk,
    input rstn,
    input en,
    input [DATAWIDTH-1:0] dividend,
    input [DATAWIDTH-1:0] divisor,
    output reg ready,
    output reg [DATAWIDTH-1:0] quotient,
    output reg [DATAWIDTH-1:0] remainder,
    output reg vld_out
);

// State definitions
typedef enum logic [1:0] {
    IDLE = 2'b00,
    SUB  = 2'b01,
    SHIFT= 2'b10,
    DONE = 2'b11
} state_type;

// Signal declarations
reg [DATAWIDTH-1:0] dividend_e, divisor_e, quotient_e, remainder_e;
reg [DATAWIDTH-1:0] shift_dividend;
reg [DATAWIDTH:0] sub_result;  // Include space for borrows
integer count;

// Current and Next state logic
reg [1:0] current_state, next_state;

// FSM and data path
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        current_state <= IDLE;
        quotient_e <= 0;
        remainder_e <= 0;
        dividend_e <= 0;
        divisor_e <= 0;
        shift_dividend <= 0;
        count <= 0;
        ready <= 1;
        vld_out <= 0;
    end else begin
        current_state <= next_state;
        case (current_state)
            IDLE: begin
                ready <= 1;
                vld_out <= 0;
                if (en) begin
                    dividend_e <= dividend;
                    divisor_e <= divisor << (DATAWIDTH-1);
                    quotient_e <= 0;
                    remainder_e <= 0;
                    count <= 0;
                    next_state <= SUB;
                end
            end
            SUB: begin
                ready <= 0;
                sub_result = dividend_e - divisor_e;
                if (!sub_result[DATAWIDTH]) begin // No borrow
                    dividend_e <= sub_result[DATAWIDTH-1:0];
                    quotient_e[count] <= 1;
                end
                next_state <= SHIFT;
            end
            SHIFT: begin
                if (count < DATAWIDTH-1) begin
                    divisor_e <= divisor_e >> 1;
                    count <= count + 1;
                    next_state <= SUB;
                end else begin
                    next_state <= DONE;
                end
            end
            DONE: begin
                ready <= 0;
                vld_out <= 1;
                quotient <= quotient_e;
                remainder <= dividend_e;
                next_state <= IDLE;
            end
        endcase
    end
end

endmodule
