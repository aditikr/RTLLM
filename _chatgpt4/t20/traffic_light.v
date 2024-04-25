module traffic_light (
    input       clk,
    input       rst_n,
    input       pass_request,
    output reg  red,
    output reg  yellow,
    output reg  green,
    output [7:0] cnt
);

    // State definition
    typedef enum logic [1:0] {
        S_GREEN = 2'b00,
        S_YELLOW = 2'b01,
        S_RED = 2'b10
    } state_t;

    // Internal registers
    reg [7:0] counter = 8'd60; // Counter for timing the light periods
    state_t state = S_RED;    // Initial state
    state_t next_state;       // Next state

    // Counter handling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 8'd60; // Reset the counter to the initial state's default (starting with Green)
            state <= S_RED;   // Start with Red state
        end else begin
            if (counter == 0) begin         // If counter reaches 0, shift to next state
                state <= next_state;
                case (next_state)           // Reload counter based on states
                    S_GREEN: counter <= (pass_request && counter > 10) ? 8'd10 : 8'd60;
                    S_YELLOW: counter <= 8'd5;
                    S_RED: counter <= 8'd10;
                endcase
            end else begin
                counter <= counter - 1;     // Else, just decrement the counter
            end
        end
    end

    // State transition logic
    always @* begin
        case (state)
            S_GREEN: begin
                if (pass_request && counter > 10) begin
                    next_state = S_YELLOW; // If pass button pressed, and green > 10s, switch soon.
                end else if (counter == 0) begin
                    next_state = S_YELLOW; // Normal transition
                end else next_state = S_GREEN;
            end
            S_YELLOW: next_state = (counter == 0) ? S_RED : S_YELLOW;
            S_RED: next_state = (counter == 0) ? S_GREEN : S_RED;
        endcase
    end

    // Output logic should be combinational and reflect the current state
    always @* begin
        red = (state == S_RED);
        yellow = (state == S_YELLOW);
        green = (state == S_GREEN);
    end

    // Assign counter to output port
    assign cnt = counter;

endmodule
