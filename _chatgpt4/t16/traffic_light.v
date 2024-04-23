module traffic_light(
    input  logic clk,
    input  logic rst_n,
    input  logic pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    // State Declaration
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        S1_RED = 2'b01,
        S2_YELLOW = 2'b10,
        S3_GREEN = 2'b11
    } state_type;

    // Registers and Wires
    reg [7:0] cnt;
    state_type state, next_state;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end
    
    // Next state logic and timing adjustments
    always @(*) begin
        case (state)
            IDLE: next_state = S1_RED;
            S1_RED: begin
                if (cnt == 0) next_state = S3_GREEN;
                else next_state = S1_RED;
            end
            S2_YELLOW: begin
                if (cnt == 0) next_state = S1_RED;
                else next_state = S2_YELLOW;
            end
            S3_GREEN: begin
                if (cnt == 0 || (pass_request && cnt > 10)) next_state = S2_YELLOW;
                but if (pass_request && cnt == 10) next_state = S3_GREEN;
                else next_state = S3_GREEN;
            end
            default: next_state = IDLE;
        endcase
    end

    // Counter and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10; // default reset value
            clock <= 0;
        end else begin
            if (state == S3_GREEN && pass_request && cnt > 10)
                cnt <= 10;
            else if (cnt == 0) begin
                case (next_state)
                    S1_RED: cnt <= 10;  // Time for red
                    S2_YELLOW: cnt <= 5; // Time for yellow
                    S3_GREEN: cnt <= 60; // Time for green
                    default: cnt <= 10;
                endcase
            end else cnt <= cnt - 1;

            clock <= cnt;  // output the current count value
        end
    end

    // Traffic light control output logic
    always @(*) begin
        red = (state == S1_RED);
        yellow = (state == S2_YELLOW);
        green = (state == S3_GREEN);
    end
endmodule
