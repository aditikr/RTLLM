
module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State definition using parameters for readability
    parameter IDLE = 2'b00;
    parameter DETECT_1 = 2'b01;
    parameter DETECT_0 = 2'b10;

    // Register to hold the current state
    reg [1:0] current_state, next_state;

    // Sequential logic for state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            data_out <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state logic and output logic
    always @(*) begin
        // Default assignment
        next_state = current_state;
        data_out = 0;

        case (current_state)
            IDLE: begin
                if (data_in == 1) begin
                    next_state = DETECT_1;
                end
            end
            DETECT_1: begin
                if (data_in == 0) begin
                    next_state = DETECT_0;
                end else if (data_in == 1) begin
                    // Stay in DETECT_1 if input remains 1
                    next_state = DETECT_1;
                end
            end
            DETECT_0: begin
                if (data_in == 0) begin
                    // Pulse detected, set output
                    data_out = 1;
                    next_state = IDLE;
                end else if (data_in == 1) begin
                    // If input goes back to 1, move to DETECT_1
                    next_state = DETECT_1;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule
