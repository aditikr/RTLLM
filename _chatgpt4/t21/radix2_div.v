module radix2_div #(
    parameter DATAWIDTH = 8
)(
    input  logic clk,
    input  logic rstn,
    input  logic en,
    input  logic [DATAWIDTH-1:0] dividend, 
    input  logic [DATAWIDTH-1:0] divisor,
    output logic ready,
    output logic [DATAWIDTH-1:0] quotient,
    output logic [DATAWIDTH-1:0] remainder,
    output logic vld_out
);

    // FSM States
    typedef enum logic [1:0] {
        IDLE, 
        SUB, 
        SHIFT, 
        DONE
    } state_t;

    // State Registers
    state_t current_state, next_state;

    // Data Registers
    logic [DATAWIDTH-1:0] dividend_e, quotient_e, remainder_e, divisor_e;
    logic [DATAWIDTH-1:0] counter;
    logic step_finished;

    // State Transition and Calculation Logic
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            current_state <= IDLE;
            dividend_e <= 0;
            quotient_e <= 0;
            remainder_e <= 0;
            divisor_e <= 0;
            counter <= 0;
            step_finished <= 1'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    if (en) begin
                        dividend_e <= dividend;
                        divisor_e <= divisor;
                        quotient_e <= 0;
                        remainder_e <= 0;
                        counter <= DATAWIDTH;
                        current_state <= SUB;
                    end
                end
                SUB: begin
                    step_finished <= 0;
                    if (dividend_e >= divisor_e) begin
                        remainder_e <= dividend_e - divisor_e;
                        quotient_e[0] <= 1;
                    end else begin
                        remainder_e <= dividend_e;
                        quotient_e[0] <= 0;
                    end
                    current_state <= SHIFT;
                end
                SHIFT: begin
                    if (counter > 1) begin
                        dividend_e <= remainder_e << 1;
                        quotient_e <= quotient_e << 1;
                        counter <= counter - 1;
                        current_state <= SUB;
                    end else begin
                        remainder_e <= dividend_e;
                        current_state <= DONE;
                    end
                end
                DONE: begin
                    step_finished <= 1;
                    if (!en) begin
                        current_state <= IDLE;
                    end
                end
            endcase
        end
    end

    // Output Assignments
    assign quotient = quotient_e;
    assign remainder = remainder_e;
    assign ready = (current_state == IDLE);
    assign vld_out = (current_state == DONE);

endmodule
