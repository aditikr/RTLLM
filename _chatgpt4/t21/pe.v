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
    always_ff @(posedge clk or negedge rst_n) begin
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
module pe(
    input  logic          clk,
    input  logic          rst,
    input  logic [31:0]   a,
    input  logic [31:0]   b,
    output logic [31:0]   c
);

    // Internal register for accumulation
    logic [31:0] accumulator;

    // Maintain output with the internal register
    assign c = accumulator;

    // Multiplication and accumulation logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            accumulator <= 32'b0;  // Reset accumulator on reset
        end else begin
            accumulator <= accumulator + (a * b);  // Accumulate the result
        end
    end
endmodule
