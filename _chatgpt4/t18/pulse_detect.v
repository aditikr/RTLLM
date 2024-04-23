module pulse_detect(
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        S0   = 2'b01,
        S01  = 2'b10
    } state_t;

    // State register
    reg state_t state, next_state;

    // State transition logic and output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset behavior
            state <= IDLE;
            data_out <= 0;
        end else begin
            // State update
            state <= next_state;

            // Output logic
            if (state == S01 && data_in == 0) begin
                data_out <= 1;
            end else begin
                data_out <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:
                if (data_in == 0)
                    next_state = S0;
                else
                    next_state = IDLE;
            S0:
                if (data_in == 1)
                    next_state = S01;
                else
                    next_state = S0;
            S01:
                if (data_in == 0)
                    next_state = S0; // Move to S0 to handle overlapping patterns
                else
                    next_state = IDLE;
            default:
                next_state = IDLE;
        endcase
    end

endmodule
