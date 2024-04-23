module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

    // Define state identifiers
    typedef enum reg [2:0] {
        S0, // Start state
        S1, // Detected 1
        S2, // Detected 10
        S3, // Detected 100
        S4, // Detected 1001
        S5  // Detected 10011
    } state_type;
    
    // Current and Next state variable
    state_type current_state, next_state;

    // State transition and output logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0;
            MATCH <= 0;
        end else begin
            current_state <= next_state;
            case (current_state)
                S0: MATCH <= 0;
                S1: MATCH <= 0;
                S2: MATCH <= 0;
                S3: MATCH <= 0;
                S4: MATCH <= 0;
                S5: MATCH <= 1;
                default: MATCH <= 0;
            endcase
        end
    end

    // Next state logic based on current state and input
    always @(*) begin
        case (current_state)
            S0: next_state = (IN == 1) ? S1 : S0;
            S1: next_state = (IN == 0) ? S2 : S1; // Loop back to S1 if another '1'
            S2: next_state = (IN == 0) ? S3 : S1;
            S3: next_state = (IN == 1) ? S4 : S0;
            S4: next_state = (IN == 1) ? S5 : (IN == 0) ? S2 : S0; // Go to S2 on '0', stay on S1 on additional '1'
            S5: next_state = (IN == 1) ? S1 : S0;
            default: next_state = S0;
        endcase
    end

endmodule
