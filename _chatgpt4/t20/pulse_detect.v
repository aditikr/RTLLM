module pulse_detect(
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    // States of the FSM
    typedef enum logic [2:0] {
        IDLE,  // Waiting for the first '0'
        S0,    // Detected a '0'
        S01    // Detected '01' sequence
    } state_type;
    
    // Current state and next state variables
    reg state_type state = IDLE;
    reg state_type next_state = IDLE;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;  // Reset to initial state on reset
        else
            state <= next_state;  // Transition to next state on clock
    end

    // Next state logic based on current state and inputs
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 0)
                    next_state = S0;
                else
                    next_state = IDLE;
            end
            S0: begin
                if (data_in == 1)
                    next_state = S01;
                else
                    next_state = S0;
            end
            S01: begin
                if (data_in == 0)
                    next_state = S0;  // Going back to S0 to check for overlapping patterns
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_out <= 0;  // Reset output
        else if (state == S01 && data_in == 0)
            data_out <= 1;  // Output a pulse if pattern matches
        else
            data_out <= 0;  // Otherwise, reset output
    end

endmodule
