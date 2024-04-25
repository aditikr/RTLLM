module radix2_div #(
    parameter DATAWIDTH = 8
)(
    input  wire                 clk,
    input  wire                 rstn,
    input  wire                 en,
    input  wire [DATAWIDTH-1:0] dividend,
    input  wire [DATAWIDTH-1:0] divisor,
    output reg                  ready,
    output reg  [DATAWIDTH-1:0] quotient,
    output reg  [DATAWIDTH-1:0] remainder,
    output reg                  vld_out
);

    // State Definitions
    localparam IDLE  = 2'b00,
               SUB   = 2'b01,
               SHIFT = 2'b10,
               DONE  = 2'b11;

    // Registers for state machine
    reg [1:0] current_state, next_state;

    // Registers for computation
    reg [DATAWIDTH-1:0] dividend_e, divisor_e;
    reg [DATAWIDTH:0] quotient_e;

    // Counter
    reg [DATAWIDTH-1:0] count;

    // Next state logic and calculations
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            current_state <= IDLE;
            quotient_e <= 0;
            dividend_e <= 0;
            divisor_e <= 0;
            quotient <= 0;
            remainder <= 0;
            count <= 0;
            ready <= 1'b1;
            vld_out <= 1'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    if (en) begin
                        quotient_e <= 0;
                        dividend_e <= dividend;
                        divisor_e <= divisor;
                        count <= DATAWIDTH;
                        ready <= 0;
                        vld_out <= 0;
                        next_state <= SUB;
                    end 
                end
                SUB: begin
                    if (dividend_e >= divisor_e) begin
                        dividend_e <= dividend_e - divisor_e;
                        quotient_e <= (quotient_e << 1) | 1;
                    end else begin
                        quotient_e <= (quotient_e << 1);
                    end
                    next_state <= SHIFT;
                end
                SHIFT: begin
                    if (count > 0) begin
                        divisor_e <= divisor_e >> 1;
                        count <= count - 1;
                        next_state <= SUB;
                    end else begin
                        next_state <= DONE;
                    end
                end
                DONE: begin
                    quotient <= quotient_e;
                    remainder <= dividend_e;
                    ready <= 1;
                    vld_out <= 1;
                    next_state <= IDLE;
                end
                default: next_state <= IDLE;
            endcase
            current_state <= next_state;
        end
    end
endmodule
