module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State declaration
typedef enum reg [1:0] {
    IDLE,   // Waiting for '0'
    S0,     // Detected '0'
    S01     // Detected '01'
} state_t;

// State register
reg [1:0] state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    next_state = state; // Default to hold state
    case (state)
        IDLE: begin
            if (data_in == 0)
                next_state = S0;
        end
        S0: begin
            if (data_in == 1)
                next_state = S01;
            else
                next_state = S0; // Stay in S0 if another '0' is received
        end
        S01: begin
            if (data_in == 0) begin
                next_state = S0; // Move to S0 as '010' can overlap
                data_out = 1;   // Output pulse detected
            end else begin
                next_state = IDLE; // No valid transition, go back to IDLE
                data_out = 0;
            end
        end
        default: begin
            next_state = IDLE;
            data_out = 0;
        end
    endcase
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 0;
    end else if (state == S01 && data_in == 0) begin
        data_out <= 1;
    end else begin
        data_out <= 0;
    end
end

endmodule
