module pulse_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic data_in,
    output logic data_out
);

    // State definitions
    typedef enum logic [1:0] {IDLE, S0, S1} state_type;
    state_type state = IDLE, next_state;

    // State update logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;  // Reset state to IDLE
        else
            state <= next_state;  // Update the state
    end

    // Next state logic
    always_comb begin
        case (state)
            IDLE:
                next_state = (data_in == 0) ? S0 : IDLE;
            S0:
                next_state = (data_in == 1) ? S1 : S0;
            S1:
                next_state = (data_in == 0) ? S0 : IDLE;
            default:
                next_state = IDLE;
        endcase
    end

    // Output logic
    assign data_out = (state == S1 && data_in == 0);  // Pulse detected on 010 pattern

endmodule
module JC_counter(
    input logic clk,
    input logic rst_n,
    output logic [63:0] Q
);

    // Register for storing the current state
    reg [63:0] Q = 64'b0;

    // Counter logic on clock rising edge or reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 64'd0;  // Reset the counter
        end else begin
            Q <= {Q[62:0], ~Q[63]};  // Shift left and invert the MSB forming a Johnson Counter
        end
    end

endmodule
