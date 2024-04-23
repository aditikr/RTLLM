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
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // State transition logic
    always_comb begin
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = S0;
                else
                    next_state = IDLE;
            end
            S0: begin
                if (data_in == 1'b1)
                    next_state = S01;
                else
                    next_state = S0;
            end
            S01: begin
                if (data_in == 1'b0)
                    next_state = S0;  // Move to S0 to handle overlapping patterns
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign data_out = (state == S01 && data_in == 1'b0);
endmodule
module right_shifter(
    input  logic clk,
    input  logic d,
    output logic [7:0] q
);

    // Register definition and initial state
    initial q = 0;

    // Shifting logic on each rising edge of the clock
    always @(posedge clk) begin
        q <= {d, q[7:1]};
    end
    
endmodule
