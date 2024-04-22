module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

    // State declaration using one-hot encoding for clarity and performance
    typedef enum reg [5:0] {
        S0 = 6'b000001, // Initial state
        S1 = 6'b000010, // Detected '1'
        S2 = 6'b000100, // Detected '10'
        S3 = 6'b001000, // Detected '100'
        S4 = 6'b010000, // Detected '1001'
        S5 = 6'b100000  // Detected '10011'
    } state_t;

    // State variables
    reg [5:0] current_state, next_state;

    // State transition logic
    always @(posedge CLK or posedge RST) begin
        if (RST)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state logic based on current state and input
    always @(*) begin
        case (current_state)
            S0: next_state = (IN == 1) ? S1 : S0;
            S1: next_state = (IN == 0) ? S2 : S1;
            S2: next_state = (IN == 0) ? S3 : S1;
            S3: next_state = (IN == 1) ? S4 : S1;
            S4: next_state = (IN == 1) ? S5 : S1;
            S5: next_state = (IN == 1) ? S1 : (IN == 0) ? S2 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic
    always @(current_state) begin
        MATCH = (current_state == S5);
    end

endmodule
