module fsm(
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    // State declaration using enumerated type for clarity
    typedef enum reg [2:0] {
        S0, // Initial state, looking for '1'
        S1, // Received '1'
        S2, // Received '10'
        S3, // Received '100'
        S4, // Received '1001'
        S5  // Received '10011', sequence complete
    } state_type;

    // Current and next state variables
    reg [2:0] state, next_state;

    // Sequential logic for state transitions
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= S0; // Reset to initial state
        else
            state <= next_state; // Move to next state
    end

    // Combinatorial logic for next state definition
    always @(*) begin
        case (state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;
            S1: next_state = (IN == 1'b0) ? S2 : S1;
            S2: next_state = (IN == 1'b1) ? S3 : S2;
            S3: next_state = (IN == 1'b1) ? S4 : S2;
            S4: next_state = (IN == 1'b1) ? S5 : S2;
            S5: next_state = S0; // After complete sequence, return to start
            default: next_state = S0; // Default case to handle undefined states
        endcase
    end

    // Output logic: MATCH is high only when the complete sequence is detected
    always @(*) begin
        MATCH = (state == S5);
    end

endmodule
