module traffic_light (
    input wire rst_n, // active low reset
    input wire clk, // clock signal
    input wire pedestrian_button, // request from pedestrian
    output reg [7:0] clock, // 8-bit counter output
    output reg red, yellow, green // traffic light outputs
);

    // Parameters for different light states
    parameter IDLE = 2'b00,
              RED = 2'b01,
              YELLOW = 2'b10,
              GREEN = 2'b11;

    // Internal signals
    reg [1:0] state, next_state;
    reg [7:0] cnt;
    reg [7:0] next_cnt;

    // State transition and counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 8'd0;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
        end
    end

    // Output and counter update logic
    always @* begin
        // Default values
        red = 0;
        yellow = 0;
        green = 0;
        next_state = state;
        next_cnt = cnt - 1;
        
        case(state)
            IDLE: begin
                next_state = RED;
                next_cnt = 8'd10; // Start with red light
            end

            RED: begin
                red = 1;
                clock = cnt;
                if (cnt == 0) begin
                    next_state = GREEN;
                    next_cnt = 8'd60; // Green light for 60 cycles
                end
            end

            YELLOW: begin
                yellow = 1;
                clock = cnt;
                if (cnt == 0) begin
                    next_state = RED;
                    next_cnt = 8'd10;
                end
            end

            GREEN: begin
                green = 1;
                clock = cnt;
                if (pedestrian_button && cnt > 8'd10) begin
                    next_cnt = 8'd10; // Shorten green time when pedestrian button is pressed
                end
                if (cnt == 0) begin
                    next_state = YELLOW;
                    next_cnt = 8'd5; // Yellow light for 5 cycles
                end
            end
        endcase
    end
    
    // Output assignments
    always @(posedge clk) begin
        red <= (state == RED);
        yellow <= (state == YELLOW);
        green <= (state == GREEN);
    end

endmodule
