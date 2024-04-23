module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State declaration
typedef enum reg [1:0] {
    IDLE = 2'b00,    // Waiting for pulse start
    PULSE_HIGH = 2'b01, // Detected a rising edge
    PULSE_LOW = 2'b10  // Detected a falling edge after a rising edge
} state_type;

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
    next_state = state; // Default to hold state unless conditions below trigger a transition
    case (state)
        IDLE: begin
            if (data_in == 1)
                next_state = PULSE_HIGH;
        end
        PULSE_HIGH: begin
            if (data_in == 0)
                next_state = PULSE_LOW;
        end
        PULSE_LOW: begin
            if (data_in == 1)
                next_state = PULSE_HIGH;
            else
                next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 0;
    end else begin
        // Set data_out to 1 only in the PULSE_LOW state when data_in is 0
        if (state == PULSE_LOW && data_in == 0)
            data_out <= 1;
        else
            data_out <= 0;
    end
end

endmodule
