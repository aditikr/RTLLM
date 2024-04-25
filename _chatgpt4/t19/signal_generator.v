module pulse_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic data_in,
    output logic data_out
);

    // State encoding
    typedef enum logic [1:0] {IDLE, S0, S01} state_t;
    state_t state = IDLE, next_state;

    // State register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // State transition logic
    always_comb begin
        case (state)
            IDLE: next_state = (data_in == 0) ? S0 : IDLE; // IDLE state transitions
            S0: next_state = (data_in == 1) ? S01 : S0;    // S0 state transitions
            S01: next_state = (data_in == 0) ? S0 : IDLE;  // S01 transitions back to S0 for overlap or resets to IDLE
            default: next_state = IDLE;                    // Default case to catch undefined states
        endcase
    end

    // Output logic
    assign data_out = (state == S01 && data_in == 0);     // Pulse detected generating output high

endmodule
module signal_generator(
    input  logic clk,
    input  logic rst_n,
    output logic [4:0] wave
);

    logic [4:0] tmp_wave;
    logic state;  // 0 is increment, 1 is decrement

    // Waveform and state update logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tmp_wave <= 0;
            state <= 0;   // Start in incrementing state
        end else begin
            if (state == 0) begin
                if (tmp_wave == 31) 
                    state <= 1;  // Change state to decrement on reaching top
                else 
                    tmp_wave <= tmp_wave + 1;
            end else begin
                if (tmp_wave == 0) 
                    state <= 0;  // Change state to increment on reaching bottom
                else 
                    tmp_wave <= tmp_wave - 1;
            end
        end
    end

    assign wave = tmp_wave; // Direct assignment to output port

endmodule
