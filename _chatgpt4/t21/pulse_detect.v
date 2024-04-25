module pulse_detect(
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg data_out
);

    // State definitions
    localparam IDLE = 2'b00;
    localparam S0 = 2'b01;   // Detected a '0'
    localparam S01 = 2'b10;  // Detected '01' sequence

    // State register
    reg [1:0] state = IDLE;
    reg [1:0] next_state;

    // Sequential logic for state transitions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0; // Reset output as well
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for next state and output
    always @(*) begin
        next_state = state; // Default to hold current state
        data_out = 1'b0;    // Default output is 0

        case(state)
            IDLE: begin
                if (data_in == 0)
                    next_state = S0;
            end
            S0: begin
                if (data_in == 1)
                    next_state = S01;
                else
                    next_state = S0;  // Continue detecting '0'
            end
            S01: begin
                if (data_in == 0) begin
                    data_out = 1'b1;  // Detected 0->1->0
                    next_state = S0;  // Move to S0 to handle overlaps
                end
                else
                    next_state = IDLE;  // No valid sequence, go back to IDLE
            end
            default: next_state = IDLE;  // Safe fall-back
        endcase
    end

endmodule
