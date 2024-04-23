module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    // State definitions
    parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

    // Registers
    reg [7:0] cnt;
    reg [1:0] state, next_state;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and output logic
    always @(*) begin
        case (state)
            idle: begin
                next_state = s1_red;
                red = 1; yellow = 0; green = 0;
            end
            s1_red: begin
                red = 1; yellow = 0; green = 0;
                if (cnt == 0) next_state = s3_green;
                else next_state = s1_red;
            end
            s2_yellow: begin
                red = 0; yellow = 1; green = 0;
                if (cnt == 0) next_state = s1_red;
                else next_state = s2_yellow;
            end
            s3_green: begin
                red = 0; yellow = 0; green = 1;
                if (cnt == 0) next_state = s2_yellow;
                else next_state = s3_green;
            end
            default: begin
                red = 0; yellow = 0; green = 0;
                next_state = idle;
            end
        endcase
    end

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;  // Default reset value
        end else begin
            if (state == s3_green && pass_request && cnt > 10) begin
                cnt <= 10;  // Shorten green time if pedestrian button is pressed
            end else if (cnt == 0) begin
                case (state)
                    s1_red: cnt <= 60;
                    s2_yellow: cnt <= 5;
                    s3_green: cnt <= 10;
                    default: cnt <= 10;
                endcase
            end else begin
                cnt <= cnt - 1;  // Normal decrement
            end
        end
    end

    // Output the counter value
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clock <= 0;
        end else begin
            clock <= cnt;
        end
    end

endmodule
