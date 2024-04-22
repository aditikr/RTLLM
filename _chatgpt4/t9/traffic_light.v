module traffic_light(
    input wire rst_n,  // Active low reset
    input wire clk,    // Clock signal
    input wire pass_request,  // Pedestrian button press
    output reg [7:0] clock,  // 8-bit counter output
    output reg red, yellow, green  // Traffic light outputs
);

    // State definitions
    parameter IDLE = 2'b00, GREEN = 2'b01, YELLOW = 2'b10, RED = 2'b11;

    // Timing constants
    parameter GREEN_TIME = 60, YELLOW_TIME = 5, RED_TIME = 10;

    // State register
    reg [1:0] state, next_state;

    // Counter
    reg [7:0] cnt;

    // State transition and counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 0;
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            case (state)
                IDLE: begin
                    state <= RED;
                    cnt <= RED_TIME;
                    red <= 1;
                    yellow <= 0;
                    green <= 0;
                end
                GREEN: begin
                    if (cnt == 0) begin
                        state <= YELLOW;
                        cnt <= YELLOW_TIME;
                        red <= 0;
                        yellow <= 1;
                        green <= 0;
                    end else if (pass_request && cnt > 10) begin
                        cnt <= 10;
                    end
                end
                YELLOW: begin
                    if (cnt == 0) begin
                        state <= RED;
                        cnt <= RED_TIME;
                        red <= 1;
                        yellow <= 0;
                        green <= 0;
                    end
                end
                RED: begin
                    if (cnt == 0) begin
                        state <= GREEN;
                        cnt <= GREEN_TIME;
                        red <= 0;
                        yellow <= 0;
                        green <= 1;
                    end
                end
            endcase

            if (cnt > 0) cnt <= cnt - 1;
        end
    end

    // Output assignment
    always @(posedge clk) begin
        clock <= cnt;  // Output the current count value
    end

endmodule
