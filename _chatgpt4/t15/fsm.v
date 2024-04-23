module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// State Declaration
reg [2:0] state, next_state;

// State Encoding
localparam S0 = 3'd0,   // Waiting for '1'
           S1 = 3'd1,   // '1' received, waiting for '0'
           S2 = 3'd2,   // '10' received, waiting for another '0'
           S3 = 3'd3,   // '100' received, waiting for '1'
           S4 = 3'd4,   // '1001' received, waiting for final '1'
           S5 = 3'd5;   // '10011' received, sequence complete

// State Transitions and Output Logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end
    else begin
        state <= next_state;
        // MATCH is only high on transition to S5
        MATCH <= (next_state == S5);
    end
end

// Next State Logic
always @(*) begin
    case (state)
        S0: next_state = IN ? S1 : S0;     // Seen '1'
        S1: next_state = IN ? S1 : S2;     // Seen '10'
        S2: next_state = IN ? S3 : S2;     // Seen '100'
        S3: next_state = IN ? S4 : S0;     // Seen '1001' or reset to S0 on '0'
        S4: next_state = IN ? S5 : S2;     // Seen '1001'1' or go to S2 on '0'
        S5: next_state = IN ? S1 : S0;     // Loop on '1', start anew on '0'
        default: next_state = S0;
    endcase
end

endmodule
