module radix2_div #(
    parameter DATAWIDTH = 8
)(
    input  wire clk,
    input  wire rstn,
    input  wire en,
    input  wire [DATAWIDTH-1:0] dividend,
    input  wire [DATAWIDTH-1:0] divisor,
    output reg  ready,
    output reg  [DATAWIDTH-1:0] quotient,
    output reg  [DATAWIDTH-1:0] remainder,
    output reg  vld_out
);

    // FSM states declaration
    localparam IDLE = 3'b000,
               INIT = 3'b001,
               SUB = 3'b010,
               SHIFT = 3'b011,
               DONE = 3'b100;

    reg [2:0] current_state, next_state;
    reg [DATAWIDTH-1:0] dividend_reg, divisor_reg;
    reg [DATAWIDTH:0] dividend_e;
    reg [DATAWIDTH:0] divisor_e;
    reg [DATAWIDTH-1:0] quotient_reg;
    integer count;

    // State transition
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // State logic and data operations
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (en) next_state = INIT;
            end
            INIT: begin
                next_state = SUB;
            end
            SUB: begin
                if (dividend_e >= divisor_e) begin
                    next_state = SHIFT;
                end else if (count == DATAWIDTH) begin
                    next_state = DONE;
                end else begin
                    next_state = SUB;
                end
            end
            SHIFT: begin
                if (count < DATAWIDTH) begin
                    next_state = SUB;
                end else begin
                    next_state = DONE;
                end
            end
            DONE: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        end
    end

    // Data assignments according to states
    always @(posedge clk) begin
        if (!rstn) begin
            quotient <= 0;
            remainder <= 0;
            dividend_e <= 0;
            divisor_e <= 0;
            quotient_reg <= 0;
            count <= 0;
            ready <= 1'b1;
            vld_out <= 1'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    ready <= 1'b1;
                    if (en) begin
                        dividend_e <= {1'b0, dividend};
                        divisor_e <= {1'b0, divisor} << DATAWIDTH; // align divisor
                        quotient_reg <= 0;
                        count <= 0;
                    end
                end
                INIT: begin
                    ready <= 1'b0;
                end
                SUB: begin
                    if (dividend_e >= divisor_e) begin
                        dividend_e <= dividend_e - divisor_e;
                        quotient_reg <= (quotient_reg << 1) | 1'b1;
                    end else begin
                        quotient_reg <= quotient_reg << 1;
                    end
                    count <= count + 1;
                end
                SHIFT: begin
                    divisor_e <= divisor_e >> 1;
                end
                DONE: begin
                    quotient <= quotient_reg;
                    remainder <= dividend_e[DATAWIDTH-1:0];
                    vld_out <= 1'b1;
                end
                default: vld_out <= 1'b0;
            endcase
        end
    end
endmodule
