module traffic_light(
    input wire clk,
    input wire rst_n,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    // State definitions
    parameter IDLE = 2'b00, RED = 2'b01, YELLOW = 2'b10, GREEN = 2'b11;

    // Registers
    reg [7:0] cnt;
    reg [1:0] state, next_state;
    reg p_green, p_yellow, p_red;

    // Timing parameters
    parameter RED_TIME = 10, YELLOW_TIME = 5, GREEN_TIME = 60;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= RED_TIME; 
        end else begin
            state <= next_state;
        end
    end

    // Traffic light control logic
    always @* begin
        case (state)
            IDLE: begin
                next_state = RED; // Start at red light
                red = 1;
                yellow = 0;
                green = 0;
            end
            RED: begin
                red = 1;
                yellow = 0;
                green = 0;
                if (cnt == 0)
                    next_state = GREEN;
                else
                    next_state = RED;
            end
            YELLOW: begin
                red = 0;
                yellow = 1;
                green = 0;
                if (cnt == 0)
                    next_state = RED;
                else
                    next_state = YELLOW;
            end
            GREEN: begin
                red = 0;
                yellow = 0;
                green = 1;
                if (pass_request && cnt > 10)
                    cnt = 10;
                if (cnt == 0)
                    next_state = YELLOW;
                else
                    next_state = GREEN;
            end
            default: next_state = IDLE;
        endcase
    end

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= RED_TIME;
        end else if (state == RED && next_state == GREEN) begin
            cnt <= GREEN_TIME;
        end else if (state == GREEN && next_state == YELLOW) begin
            cnt <= YELLOW_TIME;
        end else if (state == YELLOW && next_state == RED) begin
            cnt <= RED_TIME;
        end else begin
            cnt <= cnt - 1;
        end
    end

    // Update clock output to display current counter value
    always @* begin
        clock = cnt; // Display the countdown of the current road state
    end

    // Output registers for traffic light signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 0;
            yellow <= 0;
            green <= 0;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            p_red <= red;
            p_yellow <= yellow;
            p_green <= green;
        end
    end
endmodule
