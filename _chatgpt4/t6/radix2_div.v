
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
    localparam IDLE  = 2'b00;
    localparam SUB   = 2'b01;
    localparam SHIFT = 2'b10;
    localparam DONE  = 2'b11;

    // Registers for state machine
    reg [1:0] current_state, next_state;

    // Data registers
    reg [DATAWIDTH-1:0] dividend_e, divisor_e;
    reg [DATAWIDTH-1:0] quotient_e, remainder_e;
    reg [DATAWIDTH:0] count; // Extra bit for counting up to DATAWIDTH

    // State transition and output logic
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            current_state <= IDLE;
            quotient_e <= 0;
            remainder_e <= 0;
            dividend_e <= 0;
            divisor_e <= 0;
            count <= 0;
            ready <= 1;
            vld_out <= 0;
        end else begin
            current_state <= next_state;
            case (current_state)
                IDLE: begin
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
                    if (dividend_e >= divisor_e) begin
                        remainder_e <= dividend_e - divisor_e;
                    end else begin
                        remainder_e <= dividend_e;
                    end
                end
                SHIFT: begin
                    dividend_e <= remainder_e << 1;
                    quotient_e <= (quotient_e << 1) | (dividend_e >= divisor_e);
                    count <= count - 1;
                end
                DONE: begin
                    quotient <= quotient_e;
                    remainder <= remainder_e;
                    vld_out <= 1;
                    ready <= 1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = en ? SUB : IDLE;
            SUB: next_state = SHIFT;
            SHIFT: next_state = (count == 0) ? DONE : SUB;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule
