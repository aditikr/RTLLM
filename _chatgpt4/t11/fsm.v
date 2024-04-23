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

    // Current state and next state variables
    reg [2:0] current_state, next_state;

    // State transition and output logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0;
            MATCH <= 1'b0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic based on current state and input
    always @(*) begin
        case (current_state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;
            S1: next_state = (IN == 1'b0) ? S2 : S1;
            S2: next_state = (IN == 1'b0) ? S3 : S1;
            S3: next_state = (IN == 1'b1) ? S4 : S0;
            S4: next_state = (IN == 1'b1) ? S5 : S2;
            S5: next_state = (IN == 1'b1) ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // Output logic
    always @(*) begin
        MATCH = (current_state == S5);
    end

endmodule
