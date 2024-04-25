module pulse_detect(
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {IDLE, S0, S01} state_t;
    state_t state = IDLE;
    state_t next_state = IDLE;

    // Process state transitions and output calculations
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0; // Reset the output on reset
        end else begin
            state <= next_state;
        end
    end
    
    always_comb begin
        next_state = state; // Default to hold current state unless conditions below dictate a change
        case (state)
            IDLE:
                if (data_in == 1'b0)
                    next_state = S0;
            S0:
                if (data_in == 1'b1)
                    next_state = S01;
            S01:
                if (data_in == 1'b0)
                    next_state = S0; // Move to S0 to handle overlapping patterns
                else
                    next_state = IDLE;
            default:
                next_state = IDLE;
        endcase
        // Output logic
        data_out = (state == S01 && data_in == 1'b0); // Output pulse only once per detected pattern
    end
endmodule
module signal_generator(
    input  wire clk,
    input  wire rst_n,
    output reg  [4:0] wave
);

    // State register to determine incrementing or decrementing
    reg state = 0; // 0 for incrementing, 1 for decrementing

    // Waveform generation process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave <= 5'b0;
            state <= 0; // Begin by incrementing
        end else begin
            if (state == 0) begin
                if (wave == 31) begin
                    state <= 1;  // Start decrementing
                end else begin
                    wave <= wave + 1; // Increment wave
                end
            end else if (state == 1) begin
                if (wave == 0) begin
                    state <= 0;  // Start incrementing again
                end else begin
                    wave <= wave - 1; // Decrement wave
                end
            end
        end
    end
endmodule
