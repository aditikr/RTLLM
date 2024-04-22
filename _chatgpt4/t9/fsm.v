module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);
typedef enum reg [2:0] {
    S0, S1, S2, S3, S4, S5
} state_t;
reg [2:0] current_state, next_state;
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        MATCH <= 0;
    end else begin
        current_state <= next_state;
    end
end
always @(*) begin
    case (current_state)
        S0: next_state = (IN == 1) ? S1 : S0;
        S1: next_state = (IN == 0) ? S2 : S1;
        S2: next_state = (IN == 0) ? S3 : S1;
        S3: next_state = (IN == 1) ? S4 : S0;
        S4: next_state = (IN == 1) ? S5 : S1;
        S5: next_state = (IN == 1) ? S1 : S0;
        default: next_state = S0;
    endcase
end
always @(current_state or IN) begin
    MATCH = (current_state == S5 && IN == 1);
end
