module fsm(
    input  wire CLK,
    input  wire RST,
    input  wire IN,
    output reg  MATCH
);

    // Define the FSM states using parameters for better readability
    parameter IDLE = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5;
    reg [2:0] state, next_state;

    // State transition and output logic using the always block
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            // Reset to the initial state
            state <= IDLE;
        end else begin
            // Update state to the next state
            state <= next_state;
        end
    end
    
    // Next state logic based on current state and input
    always @* begin
        // Default to hold the current state
        next_state = state;
        MATCH = 1'b0; // default output

        case (state)
            IDLE:
                if (IN == 1'b1) next_state = S1;
            S1:
                if (IN == 1'b0) next_state = S2;
            S2:
                if (IN == 1'b0) next_state = S3;
                else next_state = S1;
            S3:
                if (IN == 1'b1) next_state = S4;
                else next_state = IDLE;
            S4:
                if (IN == 1'b1) next_state = S5;
                else next_state = S1;
            S5:
                if (IN == 1'b1) begin
                    MATCH = 1'b1; // Match found on the input 10011
                    next_state = S1;  // Prepare to detect another start or continue checking
                end else if (IN == 1'b0) next_state = S3;
        endcase
    end

endmodule
