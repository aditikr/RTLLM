module pulse_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic data_in,
    output logic data_out
);

    // State encoding
    typedef enum logic [1:0] {IDLE, S0, S01} state_t;
    state_t state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // State transition logic
    always_comb begin
        case (state)
            IDLE:
                next_state = (data_in == 1'b0) ? S0 : IDLE;
            S0:
                next_state = (data_in == 1'b1) ? S01 : S0;
            S01:
                next_state = (data_in == 1'b0) ? S0 : IDLE;
            default:
                next_state = IDLE;
        endcase
    end

    // Output logic
    assign data_out = (state == S01 && data_in == 1'b0);
  
endmodule
module fsm (
    input  logic CLK,
    input  logic RST,
    input  logic IN,
    output logic MATCH
);

    // State encoding
    typedef enum logic [2:0] {S0, S1, S2, S3, S4, MATCH_STATE} state_t;
    state_t state, next_state;

    // State register
    always @(posedge CLK or negedge RST) begin
        if (!RST)
            state <= S0;
        else
            state <= next_state;
    end

    // State transition logic
    always_comb begin
        case (state)
            S0:
                next_state = (IN == 1'b1) ? S1 : S0;
            S1:
                next_state = (IN == 1'b0) ? S2 : S1;
            S2:
                next_state = (IN == 1'b0) ? S3 : S1;
            S3:
                next_state = (IN == 1'b1) ? S4 : S0;
            S4:
                next_state = (IN == 1'b1) ? MATCH_STATE : S2;
            MATCH_STATE:
                next_state = (IN == 1'b1) ? S1 : S0;
            default:
                next_state = S0;
        endcase
    end

    // Output logic
    assign MATCH = (state == MATCH_STATE);

endmodule
