module radix2_div #(
    parameter DATAWIDTH = 8
)(
    input  wire                    clk,
    input  wire                    rstn,
    input  wire                    en,
    input  wire [DATAWIDTH-1:0]    dividend,
    input  wire [DATAWIDTH-1:0]    divisor,
    output reg                     ready,
    output reg [DATAWIDTH-1:0]     quotient,
    output reg [DATAWIDTH-1:0]     remainder,
    output reg                     vld_out
);

// Define state encoding using parameters or localparams
localparam IDLE  = 2'b00,
           SUB   = 2'b01,
           SHIFT = 2'b10,
           DONE  = 2'b11;

// State registers
reg [1:0] current_state, next_state;

// Internal data registers
reg [DATAWIDTH-1:0] dividend_e;
reg [DATAWIDTH:0]   divisor_e; // One bit larger to handle shifts
reg [DATAWIDTH-1:0] quotient_e;
reg [DATAWIDTH-1:0] remainder_e;
reg [DATAWIDTH:0]   count;

// State transitions and operations
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        quotient_e <= 0;
        dividend_e <= 0;
        divisor_e <= 0;
        remainder_e <= 0;
        count <= 0;
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
        case (current_state)
            IDLE: begin
                if (en) begin
                    dividend_e <= dividend;
                    divisor_e <= divisor << (DATAWIDTH-1); // Align divisor
                    quotient_e <= 0;
                    remainder_e <= 0;
                    count <= DATAWIDTH;
                    next_state <= SUB;
                end
            end
            SUB: begin
                if (divisor_e <= dividend_e) begin
                    dividend_e <= dividend_e - divisor_e;
                    quotient_e <= (quotient_e << 1) | 1;
                end else begin
                    quotient_e <= quotient_e << 1;
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
                vld_out <= 1'b1;
                next_state <= IDLE;
            end
            default: begin
                next_state <= IDLE;
            end
        endcase
    end
end

// Output signal for readiness
always @(*) begin
    ready = (current_state == IDLE);
end

endmodule
