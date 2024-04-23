module pulse_detect(
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg data_out
);

    // Define the states
    typedef enum logic [1:0] {
        S_IDLE = 2'b00,
        S0 = 2'b01,
        S01 = 2'b10
    } state_t;

    // State registers
    state_t state, next_state;

    // State transition logic and output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_IDLE;  // Reset to initial state
            data_out <= 1'b0; // Ensure output is 0 on reset
        end else begin
            state <= next_state; // Transition to next state
        end
    end

    // Next state logic based on current state and data_in
    always_comb begin
        case (state)
            S_IDLE: begin
                if (data_in == 1'b0)
                    next_state = S0; // Transition to S0 if 0 detected
                else
                    next_state = S_IDLE;
            end
            S0: begin
                if (data_in == 1'b1)
                    next_state = S01; // Transition to S01 if 1 detected
                else
                    next_state = S0; // Remain in S0 if 0 continues
            end
            S01: begin
                if (data_in == 1'b0)
                    next_state = S0;  // Transition to S0 if 0 detected, handle 010 pattern
                else
                    next_state = S_IDLE; // Go to IDLE if 1 continues
            end
            default: begin
                next_state = S_IDLE; // Default case, go back to IDLE
            end
        endcase
    end

    // Output logic: Set output high when we are in S01 and input is 0
    always_comb begin
        if (state == S01 && data_in == 1'b0)
            data_out = 1'b1;
        else
            data_out = 1'b0;
    end

endmodule
