module radix2_div #(
    parameter DATAWIDTH = 8
)(
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
localparam IDLE  = 2'b00,
           SUB   = 2'b01,
           SHIFT = 2'b10,
           DONE  = 2'b11;

// FSM registers
reg [1:0] current_state, next_state;

// Data registers
reg [DATAWIDTH-1:0] dividend_e, divisor_e;
reg [DATAWIDTH-1:0] quotient_e;
reg [DATAWIDTH*2-1:0] remainder_e; // Extended to hold shifts
reg [DATAWIDTH-1:0] count;

// State transition logic
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic and operations
always @(*) begin
    case (current_state)
        IDLE: begin
            if (en) next_state = SUB;
            else next_state = IDLE;
        end
        SUB: begin
            if (count == 0) next_state = DONE;
            else next_state = SHIFT;
        end
        SHIFT: begin
            next_state = SUB;
        end
        DONE: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Operations within each state
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        dividend_e <= 0;
        divisor_e <= 0;
        quotient_e <= 0;
        remainder_e <= 0;
        count <= 0;
        ready <= 1;
        vld_out <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                ready <= 1;
                vld_out <= 0;
                if (en) begin
                    dividend_e <= dividend;
                    divisor_e <= divisor;
                    quotient_e <= 0;
                    remainder_e <= 0;
                    count <= DATAWIDTH;
                    ready <= 0;
                end
            end
            SUB: begin
                if (remainder_e[DATAWIDTH*2-1:DATAWIDTH] >= divisor_e) begin
                    remainder_e[DATAWIDTH*2-1:DATAWIDTH] = remainder_e[DATAWIDTH*2-1:DATAWIDTH] - divisor_e;
                    quotient_e[DATAWIDTH-1] = 1;
                end
                remainder_e = remainder_e << 1;
                remainder_e[0] = dividend_e[DATAWIDTH-1];
                dividend_e = dividend_e << 1;
                count = count - 1;
            end
            SHIFT: begin
                quotient_e = quotient_e << 1;
            end
            DONE: begin
                quotient = quotient_e;
                remainder = remainder_e[DATAWIDTH-1:0];
                vld_out <= 1;
            end
        endcase
    end
end

endmodule
