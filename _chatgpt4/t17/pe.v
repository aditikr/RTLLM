module pulse_detect(
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State definitions
    typedef enum logic [1:0] {
        IDLE,
        S0,
        S01
    } state_type;

    // State variables
    state_type state, next_state;

    // State register
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        next_state = state; // Default state: hold current state
        case (state)
            IDLE:
                if (data_in == 0)
                    next_state = S0;
            S0:
                if (data_in == 1)
                    next_state = S01;
                else
                    next_state = S0;
            S01:
                if (data_in == 0)
                    next_state = S0;  // Overlap scenario handling
                else
                    next_state = IDLE;
            default:
                next_state = IDLE;
        endcase
    end

    // Output logic
    always_comb begin
        if (state == S01 && data_in == 0)
            data_out = 1;
        else
            data_out = 0;
    end

endmodule
module pe(
    input  wire         clk,
    input  wire         rst,
    input  wire [31:0]  a,
    input  wire [31:0]  b,
    output reg  [31:0]  c
);

    // Calculation intermediate variable
    wire [63:0] product = a * b;

    // Accumulation Register with reset
    always @(posedge clk or posedge rst) begin
        if (rst)
            c <= 32'd0;   // Reset accumulator
        else
            c <= c + product[31:0]; // Accumulate the lower 32 bits of product
    end

endmodule
