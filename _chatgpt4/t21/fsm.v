module pulse_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic data_in,
    output logic data_out
);

    // State encoding
    enum logic [1:0] {IDLE, S0, S01} state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // State transition logic
    always_comb begin
        case (state)
            IDLE:
                if (data_in == 1'b0)
                    next_state = S0;
                else
                    next_state = IDLE;
            S0:
                if (data_in == 1'b1)
                    next_state = S01;
                else
                    next_state = S0; 
            S01:
                if (data_in == 1'b0)
                    next_state = S0;  // Move to S0 to handle overlapping patterns
                else
                    next_state = IDLE;
            default: next_state = IDLE;
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
    typedef enum logic [2:0] {
        IDLE, S1, S10, S100, S1001, S10011
    } state_t;
    
    state_t state, next_state;

    // State register
    always @(posedge CLK, negedge RST) begin
        if (!RST)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (Mealy FSM)
    always_comb begin
        case (state)
            IDLE:
                next_state = (IN == 1) ? S1 : IDLE;
            S1:
                next_state = (IN == 0) ? S10 : S1;
            S10:
                next_state = (IN == 0) ? S100 : S1;
            S100:
                next_state = (IN == 1) ? S1001 : S10;
            S1001:
                next_state = (IN == 1) ? S10011 : S10;
            S10011:
                next_state = (IN == 0) ? IDLE : S1;  
            default:
                next_state = IDLE;
        endcase
    end

    // Output logic (Mealy)
    assign MATCH = (state == S10011 && IN == 1);

endmodule
