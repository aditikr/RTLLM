module radix2_div #(
    parameter DATAWIDTH = 8
)(
    input logic clk,
    input logic rstn,
    input logic en,
    input logic [DATAWIDTH-1:0] dividend,
    input logic [DATAWIDTH-1:0] divisor,
    output logic ready,
    output logic [DATAWIDTH-1:0] quotient,
    output logic [DATAWIDTH-1:0] remainder,
    output logic vld_out
);

    // State definitions
    typedef enum logic [1:0] {
        IDLE,
        SUB,
        SHIFT,
        DONE
    } state_t;

    // State variables
    state_t current_state, next_state;

    // Data registers
    logic [DATAWIDTH-1:0] dividend_e, divisor_e, quotient_e, remainder_e;
    logic [DATAWIDTH-1:0] temp_divisor;
    integer count;

    // State register
    always_ff @(posedge clk, negedge rstn) begin
        if (!rstn) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and logic computation
    always_comb begin
        case (current_state)
            IDLE: begin
                if (en) begin
                    next_state = SUB;
                    dividend_e = dividend;
                    divisor_e = divisor;
                    quotient_e = 0;
                    remainder_e = 0;
                    temp_divisor = divisor << (DATAWIDTH-1);
                    count = DATAWIDTH;
                end else begin
                    next_state = IDLE;
                end
            end
            SUB: begin
                if (dividend_e >= temp_divisor) begin
                    dividend_e = dividend_e - temp_divisor;
                    quotient_e = (quotient_e << 1) | 1;
                end else begin
                    quotient_e = quotient_e << 1;
                end
                next_state = SHIFT;
            end
            SHIFT: begin
                if (count > 0) begin
                    temp_divisor = temp_divisor >> 1;
                    count = count - 1;
                    next_state = SUB;
                end else begin
                    next_state = DONE;
                end
            end
            DONE: begin
                remainder_e = dividend_e;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output assignments
    assign ready = (current_state == IDLE);
    assign quotient = quotient_e;
    assign remainder = remainder_e;
    assign vld_out = (current_state == DONE);

    // Asynchronously reset all internal signals
    always_ff @(negedge rstn) begin
        if (!rstn) begin
            current_state <= IDLE;
            dividend_e <= 0;
            divisor_e <= 0;
            quotient_e <= 0;
            remainder_e <= 0;
            temp_divisor <= 0;
            count <= 0;
        end
    end

endmodule
