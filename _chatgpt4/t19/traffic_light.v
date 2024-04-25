module traffic_light(
    input clk,
    input rst_n,
    input pass_request,
    output reg red,
    output reg yellow,
    output reg green,
    output [7:0] clock
);

    // State definitions
    typedef enum logic [1:0] {
        RED = 2'b00,
        YELLOW = 2'b01,
        GREEN = 2'b10
    } state_t;

    // Registers
    reg [1:0] state, next_state;
    reg [7:0] cnt;
    reg [7:0] next_cnt;
    reg [2:0] p_signals;

    // Parameters
    localparam RED_DURATION = 10;
    localparam YELLOW_DURATION = 5;
    localparam GREEN_DURATION = 60;
    localparam REDUCED_GREEN_DURATION = 10;

    // Next state logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
            cnt <= RED_DURATION;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
        end
    end

    // State transition and count management
    always_comb begin
        next_state = state;
        next_cnt = cnt - 1;

        case (state)
            RED: begin
                if (cnt == 0) begin
                    next_state = GREEN;
                    next_cnt = GREEN_DURATION;
                end
            end
            YELLOW: begin
                if (cnt == 0) begin
                    next_state = RED;
                    next_cnt = RED_DURATION;
                end
            end
            GREEN: begin
                if (cnt == 0 || (pass_request && cnt > REDUCED_GREEN_DURATION)) begin
                    next_state = YELLOW;
                    next_cnt = YELLOW_DURATION;
                end else if (pass_request && cnt <= REDUCED_GREEN_DURATION) begin
                    next_cnt = cnt; // Remain unchanged if less than REDUCED_GREEN_DURATION
                end
            end
        endcase
    end

    // Output logic
    always_comb begin
        red = (state == RED);
        yellow = (state == YELLOW);
        green = (state == GREEN);
    end

    // Output clock connection
    assign clock = cnt;

endmodule
