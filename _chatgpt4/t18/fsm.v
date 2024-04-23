module fsm(
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    // State declarations
    typedef enum logic[2:0] {
        S0, // IDLE or waiting state
        S1, // Detected 1
        S2, // Detected 10
        S3, // Detected 100
        S4, // Detected 1001
        S5  // Detected 10011 (complete sequence)
    } state_t;

    state_t current_state, next_state;

    // State transition logic (comb block)
    always @(*) begin
        case (current_state)
            S0: next_state = (IN == 1) ? S1 : S0;
            S1: next_state = (IN == 0) ? S2 : S1;
            S2: next_state = (IN == 0) ? S3 : S1;
            S3: next_state = (IN == 1) ? S4 : S0;
            S4: next_state = (IN == 1) ? S5 : S2;
            S5: next_state = (IN == 1) ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // State register (sequential block)
    always @(posedge CLK or negedge RST) begin
        if (!RST)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Output logic
    always @(posedge CLK) begin
        if (!RST)
            MATCH <= 0;
        else
            MATCH <= (current_state == S4 && IN == 1);
    end

endmodule
