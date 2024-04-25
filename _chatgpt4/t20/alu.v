module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State Encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        S0   = 2'b01,
        S01  = 2'b10
    } state_t;

    state_t state = IDLE, next_state = IDLE;

    // State Transition and Output Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 0;
        end else begin
            state <= next_state;
            data_out <= (state == S01 && data_in == 1'b0); // Detecting 010 pattern
        end
    end

    always @(*) begin
        case (state)
            IDLE: next_state = (data_in == 0) ? S0 : IDLE;
            S0:   next_state = (data_in == 1) ? S01 : S0;
            S01:  next_state = (data_in == 0) ? S0 : IDLE;
            default: next_state = IDLE;
        endcase
    end
endmodule
module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output reg  zero,
    output reg  carry,
    output reg  negative,
    output reg  overflow,
    output reg  flag
);

    wire [31:0] sum = a + b;
    wire [31:0] diff = a - b;

    // ALU Operation
    always @(*) begin
        case (aluc)
            6'b100000: r = sum;                        // ADD
            6'b100001: r = sum;                        // ADDU
            6'b100010: r = diff;                       // SUB
            6'b100011: r = diff;                       // SUBU
            6'b100100: r = a & b;                      // AND
            6'b100101: r = a | b;                      // OR
            6'b100110: r = a ^ b;                      // XOR
            6'b100111: r = ~(a | b);                   // NOR
            6'b101010: r = ($signed(a) < $signed(b));  // SLT
            6'b101011: r = (a < b);                    // SLTU
            6'b000000: r = b << a[4:0];                // SLL
            6'b000010: r = b >> a[4:0];                // SRL
            6'b000011: r = $signed(b) >>> a[4:0];      // SRA
            6'b000100: r = b << a[4:0];                // SLLV
            6'b000110: r = b >> a[4:0];                // SRLV
            6'b000111: r = $signed(b) >>> a[4:0];      // SRAV
            6'b001111: r = b << 16;                    // LUI
            default:   r = 32'bz;
        endcase

        // Output Flags
        zero = (r == 0);
        carry = (aluc == 6'b100000 || aluc == 6'b100001) && (sum[32] != sum[31]);
        overflow = (aluc == 6'b100000 || aluc == 6'b100010) && (sum[32] != sum[31]);
        negative = r[31];
        flag = (aluc == 6'b101010) || (aluc == 6'b101011);
    end
endmodule
