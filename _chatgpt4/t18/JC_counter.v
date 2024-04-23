module pulse_detect(
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE, S0, S01
    } state_type;

    state_type state = IDLE, next_state = IDLE;

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
            IDLE: next_state = (data_in == 0) ? S0 : IDLE;
            S0:   next_state = (data_in == 1) ? S01 : S0;
            S01:  next_state = (data_in == 0) ? S0 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always_comb begin
        data_out = (state == S01 && data_in == 0);
    end

endmodule
module JC_counter(
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

    // Counter update logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            Q <= 64'b0;
        end else begin
            // Counter increment or decrement logic
            if (Q[0] == 1'b0) begin
                // Append '1' at the MSB when LSB is '0'
                Q <= {1'b1, Q[63:1]};
            end else begin
                // Append '0' at the MSB when LSB is '1'
                Q <= {1'b0, Q[63:1]};
            end
        end
    end

endmodule
