
module radix2_div #(
    parameter DATAWIDTH = 8
)(
    input clk,
    input rstn,
    input en,
    input [DATAWIDTH-1:0] dividend,
    input [DATAWIDTH-1:0] divisor,
    output reg ready,
    output reg [DATAWIDTH-1:0] quotient,
    output reg [DATAWIDTH-1:0] remainder,
    output reg vld_out
);

// State definitions
parameter IDLE = 2'b00;
parameter SUB = 2'b01;
parameter SHIFT = 2'b10;
parameter DONE = 2'b11;

// State and data registers
reg [1:0] current_state, next_state;
reg [DATAWIDTH*2-1:0] dividend_e, divisor_e;
reg [DATAWIDTH-1:0] quotient_e, remainder_e;
reg [3:0] count;

// State transition and data computation
always @(*) begin
    case (current_state)
        IDLE: begin
            ready = 1'b1;
            if (en) begin
                next_state = SUB;
                dividend_e = {dividend, {DATAWIDTH{1'b0}}};
                divisor_e = {divisor, {DATAWIDTH{1'b0}}};
                count = 0;
            end
        end
        SUB: begin
            if (dividend_e >= divisor_e) begin
                dividend_e = dividend_e - divisor_e;
                quotient_e = quotient_e + (1 << count);
            end
            next_state = SHIFT;
        end
        SHIFT: begin
            if (count < DATAWIDTH) begin
                dividend_e = dividend_e << 1;
                count = count + 1;
                next_state = SUB;
            end
            else begin
                next_state = DONE;
            end
        end
        DONE: begin
            ready = 1'b0;
            quotient = quotient_e;
            remainder = dividend_e;
            vld_out = 1'b1;
            if (!en) begin
                next_state = IDLE;
            end
        end
    endcase
end

// State transition
always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

// Reset logic
always @(negedge rstn) begin
    if (~rstn) begin
        dividend_e <= 0;
        divisor_e <= 0;
        quotient_e <= 0;
        remainder_e <= 0;
        count <= 0;
        ready <= 0;
        vld_out <= 0;
    end
end

endmodule
