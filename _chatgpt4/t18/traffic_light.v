module traffic_light(
    input clk,
    input rst_n,
    input pass_request,
    output reg [7:0] clock,
    output reg red, yellow, green
);

    // Enumeration for the state machine
    typedef enum {IDLE, S1_RED, S2_YELLOW, S3_GREEN} state_type;
    state_type state, next_state;

    // Internal counters
    reg [7:0] counter;

    // Next state and update logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            red <= 0;
            yellow <= 0;
            green <= 0;
            counter <= 0;
        end else begin
            state <= next_state;
            case(state)
                S1_RED: red <= 1;
                S2_YELLOW: yellow <= 1;
                S3_GREEN: green <= 1;
                default: begin
                    red <= 0;
                    yellow <= 0;
                    green <= 0;
                end
            endcase
        end
    end

    // Counter management
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 10;  // default reset value, can be adjusted
        end else begin
            // Check if it's time to change states based on the counter
            if (counter == 0) begin
                case(state)
                    S1_RED: next_state <= S3_GREEN;
                    S2_YELLOW: next_state <= S1_RED;
                    S3_GREEN: next_state <= S2_YELLOW;
                    default: next_state <= S1_RED;
                endcase
            end
            // Decrement the counter if it's not zero
            if (counter > 0) begin
                counter <= counter - 1;
            end
        end
    end

    // Request and timing adjustment
    always @* begin
        case (state)
            S3_GREEN: begin
                if (pass_request && counter > 10) begin
                    counter = 10;
                end else if (counter == 0) begin
                    counter = 5;  // Set for yellow
                end
            end
            S2_YELLOW: begin
                if (counter == 0) begin
                    counter = 10;  // Set for red
                end
            end
            S1_RED: begin
                if (counter == 0) begin
                    counter = 60;  // Set for green
                end
            end
            default: counter = 10;
        endcase
    end

    // Update output clock from counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clock <= 0;
        end else begin
            clock <= counter;
        end
    end

endmodule
