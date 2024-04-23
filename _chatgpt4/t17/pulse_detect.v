module pulse_detect(
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    // State definitions
    typedef enum logic [1:0] {
        IDLE = 2'b00,   // Idle or Reset state
        S0   = 2'b01,   // Detected a 0
        S01  = 2'b10    // Detected 0 -> 1
    } state_type;

    // State registers
    state_type state = IDLE, next_state = IDLE;

    // Sequential logic for state updating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for state transitions and output control
    always @* begin
        next_state = state; // Default to hold the current state
        data_out = 1'b0; // Default output is 0

        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = S0; // Transition to S0 on seeing '0'
            end
            S0: begin
                if (data_in == 1'b1)
                    next_state = S01; // Transition to S01 on seeing '1'
            end
            S01: begin
                if (data_in == 1'b0) begin
                    next_state = S0; // Transition back to S0 on seeing '0' again but output a pulse
                    data_out = 1'b1;
                end else begin
                    next_state = IDLE; // If a '1' continues, go to IDLE
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule
