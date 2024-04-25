module traffic_light (
    input wire clk,
    input wire rst_n,
    input wire pass_request,
    output reg red,
    output reg yellow,
    output reg green,
    output reg [7:0] clock
);
    // State Definitions
    typedef enum logic [1:0] {
        STATE_GREEN = 2'b00,
        STATE_YELLOW = 2'b01,
        STATE_RED = 2'b10
    } state_type;
    
    // State and Counter Variables
    state_type state, next_state;
    reg [7:0] cnt, next_cnt;

    // Constants for timing durations
    parameter GREEN_DURATION = 60;
    parameter YELLOW_DURATION = 5;
    parameter RED_DURATION = 10;
    parameter REDUCED_GREEN_DURATION = 10;

    // State transition logic and output setup
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= STATE_RED;
            cnt <= RED_DURATION;
            red <= 1;
            yellow <= 0;
            green <= 0;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
            red <= (state == STATE_RED);
            yellow <= (state == STATE_YELLOW);
            green <= (state == STATE_GREEN);
        end
    end

    // Next state and counter logic
    always @* begin
        next_state = state;
        next_cnt = cnt - 1;

        case (state)
            STATE_GREEN: begin
                if (cnt == 0 || (pass_request && cnt > REDUCED_GREEN_DURATION)) begin
                    next_state = STATE_YELLOW;
                    next_cnt = YELLOW_DURATION;
                end
            end
            STATE_YELLOW: begin
                if (cnt == 0) begin
                    next_state = STATE_RED;
                    next_cnt = RED_DURATION;
                end
            end
            STATE_RED: begin
                if (cnt == 0) begin
                    next_state = STATE_GREEN;
                    next_cnt = GREEN_DURATION;
                end
            end
        endcase
    end

    // Output clock assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clock <= 0;
        else
            clock <= cnt;
    end
endmodule
