
module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

    // State encoding
    parameter S0 = 3'b000, // Initial state
              S1 = 3'b001, // Detected 1
              S2 = 3'b010, // Detected 10
              S3 = 3'b011, // Detected 100
              S4 = 3'b100, // Detected 1001
              S5 = 3'b101; // Detected 10011

    // Current and next state declaration
    reg [2:0] current_state, next_state;

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
            S0: next_state = IN ? S1 : S0;
            S1: next_state = IN ? S1 : S2;
            S2: next_state = IN ? S3 : S2;
            S3: next_state = IN ? S1 : S4;
            S4: next_state = IN ? S5 : S2;
            S5: next_state = IN ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // Output logic: MATCH is high only in state S5 when IN is 1
    always @(posedge CLK or posedge RST) begin
        if (RST)
            MATCH <= 0;
        else if (current_state == S4 && IN == 1)
            MATCH <= 1;
        else
            MATCH <= 0;
    end

endmodule
