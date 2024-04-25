module pulse_detect(
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {IDLE, S0, S01} state_type;
    reg state_type state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Transition logic
    always @(*) begin
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
    always @(posedge clk) begin
        if (state == S01 && data_in == 1'b0)
            data_out <= 1'b1;
        else
            data_out <= 1'b0;
    end
endmodule
module JC_counter(
    input  wire clk,
    input  wire rst_n,
    output reg [63:0] Q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 0;
        end else begin
            // Update based on the least significant bit
            if (Q[0] == 0)
                Q <= {1'b1, Q[63:1]};
            else
                Q <= {1'b0, Q[63:1]};
        end
    end
endmodule
