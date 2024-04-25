module radix2_div #(
    parameter DATAWIDTH = 8
)(
    input  wire                     clk,
    input  wire                     rstn,
    input  wire                     en,
    input  wire [DATAWIDTH-1:0]     dividend,
    input  wire [DATAWIDTH-1:0]     divisor,
    output reg                      ready,
    output reg [DATAWIDTH-1:0]      quotient,
    output reg [DATAWIDTH-1:0]      remainder,
    output reg                      vld_out
);

    // Enumerate FSM states
    localparam IDLE = 2'b00,
               SUB  = 2'b01,
               SHIFT= 2'b10,
               DONE = 2'b11;

    // State registers
    reg [1:0] current_state, next_state;

    // Data registers
    reg [DATAWIDTH-1:0] dividend_e, quotient_e, remainder_e;
    reg [DATAWIDTH:0] divisor_e;
    reg [4:0] count;

    // State transitions and calculations
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            current_state <= IDLE;
            quotient <= 0;
            remainder <= 0;
            ready <= 1;
            vld_out <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    if (en) begin
                        dividend_e <= dividend;
                        divisor_e <= divisor << (DATAWIDTH-1);
                        quotient_e <= 0;
                        remainder_e <= 0;
                        count <= DATAWIDTH;
                        next_state <= SUB;
                        ready <= 0;
                    end
                end
                SUB: begin
                    if (dividend_e >= divisor_e) begin
                        dividend_e <= dividend_e - divisor_e;
                        quotient_e <= quotient_e | (1 << (count-1));
                    end
                    next_state <= SHIFT;
                end
                SHIFT: begin
                    divisor_e <= divisor_e >> 1;
                    count <= count - 1;
                    if (count == 0)
                        next_state <= DONE;
                    else
                        next_state <= SUB;
                end
                DONE: begin
                    quotient <= quotient_e;
                    remainder <= dividend_e;
                    vld_out <= 1;
                    ready <= 1;
                    next_state <= IDLE;
                end
                default: next_state <= IDLE;
            endcase
            current_state <= next_state;
        end
    end

    // Output logic
    always @(*) begin
        ready = (current_state == IDLE);
    end

endmodule
