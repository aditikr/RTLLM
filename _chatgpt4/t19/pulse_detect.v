module pulse_detect(
    input  wire clk,      // Clock signal
    input  wire rst_n,    // Asynchronous reset, active low
    input  wire data_in,  // One-bit input signal
    output reg  data_out  // Pulse detection output
); 

    // Definition of states
    typedef enum logic [1:0] {
        IDLE = 2'b00,  // Idle state
        S0   = 2'b01,  // Detected '0'
        S01  = 2'b10   // Detected '01'
    } state_type;

    // State declaration
    reg state_type state, next_state;

    // State register update on clock edge or reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b0)       // Wait for '0' in IDLE
                    next_state = S0;
                else
                    next_state = IDLE;
            end
            S0: begin
                if (data_in == 1'b1)       // Transition on '1' after '0'
                    next_state = S01;
                else
                    next_state = S0;       // Stay in S0 if repeating '0' are seen
            end
            S01: begin
                if (data_in == 1'b0)       // Complete pattern 0->1->0 detected
                    next_state = S0;       // Return to S0 to handle overlapping pattern '01010'
                else
                    next_state = IDLE;     // If '1' continues, go to IDLE
            end
            default: next_state = IDLE;
        endcase
  end

    // Output logic
    always @(*) begin
        // Output is high only when in state S01 and a '0' is detected again
        data_out = (state == S01 && data_in == 1'b0);
    end
endmodule
