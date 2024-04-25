module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

    // State encoding with a separate state for each bit of the sequence
    typedef enum logic [3:0] {
        IDLE    = 4'd0,
        S1      = 4'd1,
        S2      = 4'd2,
        S3      = 4'd3,
        S4      = 4'd4,
        S5      = 4'd5
    } state_t;

    state_t state, next_state;

    // State register
    always_ff @(posedge CLK or negedge RST) begin
        if (!RST) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        case (state)
            IDLE: begin
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;  // Loop back in case of 11
            end
            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else
                    next_state = S1;  // Back to check for sequential '1's
            end
            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S2;  // Continue in '0' state
            end
            S4: begin
                if (IN == 1'b1)
                    next_state = S5;
                else
                    next_state = S1;  // Fall back to initial state of the sequence
            end
            S5: begin
                // After a complete 10011 pattern, check for overlapping patterns
                if (IN == 1'b1)
                    next_state = S5;
                else
                    next_state = S2;  // Check for a new potential sequence start after 110
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always_comb begin
        if (state == S5 && IN == 1'b1)
            MATCH = 1'b1;
        else
            MATCH = 1'b0;
    end

endmodule
