module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State definitions
    localparam [1:0] S0 = 2'b00;  // Looking for first '0'
    localparam [1:0] S1 = 2'b01;  // Found '0', looking for '1'
    localparam [1:0] S2 = 2'b10;  // Found '01', looking for next '0'
    
    // State register
    reg [1:0] state, next_state;

    // Sequential logic for state transitions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S0;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

    // Combinatorial logic for next state and output generation
    always @(*) begin
        next_state = state;  // Default: hold state
        data_out = 1'b0;     // Default: no pulse detected

        case (state)
            S0: begin
                if (data_in == 1'b0)
                    next_state = S1;
            end
            S1: begin
                if (data_in == 1'b1)
                    next_state = S2;
                else
                    next_state = S1; // Stay in S1 if we see continuous '0's
            end
            S2: begin
                if (data_in == 1'b0) begin
                    data_out = 1'b1;  // Pulse detected
                    next_state = S1;  // Look for another '1' or stay at '0'
                end
                else begin
                    next_state = S1;  // No '0' after '1' detected, fall back to look for '1'
                end
            end
            default: begin
                next_state = S0;  // If somehow in undefined state, reset to S0
            end
        end
    end

endmodule
