module pulse_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic data_in,
    output logic data_out
);

    // State definitions
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

    // Next state logic and output generation
    always_comb begin
        next_state = state; // default to stay in the current state
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = S0;
            end
            S0: begin
                if (data_in == 1'b1)
                    next_state = S01;
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
    output reg [7:0] q
);

    // Initialize the shift register
    initial begin
        q = 8'b0;
    end

    // On each clock edge, shift right and insert new input bit at MSB
    always @(posedge clk) begin
        q <= {d, q[7:1]}; // Shift right, insert input 'd' at MSB
    end

endmodule
