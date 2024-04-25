module pulse_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic data_in,
    output logic data_out
);

    // State encoding
    enum logic [1:0] {IDLE, S0, S01} state, next_state;

    // State register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // State transition logic and output setting
    always_comb begin
        // Default assignments
        next_state = state;
        data_out = 1'b0; // Default output is low

        case (state)
            IDLE:
                if (data_in == 0)
                    next_state = S0;
            S0:
                if (data_in == 1)
                    next_state = S01;
            S01:
                if (data_in == 0) begin
                    next_state = S0;
                    data_out = 1'b1; // Detect "010" and output
                end
            default: next_state = IDLE;
        endcase
    end
endmodule
module JC_counter (
    input  logic clk,
    input  logic rst_n,
    output logic [63:0] Q
);

    // Sequential behavior for counter update
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 64'd0; // Reset condition
        end else begin
            if (Q[0] == 0) begin
                Q <= {1'b0, Q[63:1]}; // Right shift, wrap around '0' to MSB
            end else begin
                Q <= {Q[63], Q[63:1]}; // Right shift, MSB remains, LSB replicated to MSB
            end
        end
    end
endmodule
