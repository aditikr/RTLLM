module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);

// Defining operation codes
parameter ADD  = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB  = 6'b100010;
parameter SUBU = 6'b100011;
parameter AND  = 6'b100100;
parameter OR   = 6'b100101;
parameter XOR  = 6'b100110;
parameter NOR  = 6'b100111;
parameter SLT  = 6'b101010;
parameter SLTU = 6'b101011;
parameter SLL  = 6'b000000;
parameter SRL  = 6'b000010;
parameter SRA  = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI  = 6'b001111;

// Temporary Variables to hold results
reg [31:0] result;
reg carry_out;
reg overflow_flag;
integer temp;

always @(*) begin
    carry_out = 0;
    overflow_flag = 0;
    flag = 0; // Default to zero

    case (aluc)
        ADD: {carry_out, result} = a + b;
        ADDU: result = a + b;
        SUB: begin
            {carry_out, result} = a - b;
            overflow_flag = ((a[31] & ~b[31] & ~result[31]) | (~a[31] & b[31] & result[31]));
        end
        SUBU: result = a - b;
        AND: result = a & b;
        OR: result = a | b;
        XOR: result = a ^ b;
        NOR: result = ~(a | b);
        SLT: begin
            result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            flag = 1;
        end
        SLTU: begin
            result = (a < b) ? 32'd1 : 32'd0;
            flag = 1;
        end
        SLL: result = b << a[4:0];
        SRL: result = b >> a[4:0];
        SRA: result = $signed(b) >>> a[4:0];
        SLLV: result = b << (a[4:0] & 5'h1F);
        SRLV: result = b >> (a[4:0] & 5'h1F);
        SRAV: result = $signed(b) >>> (a[4:0] & 5'h1F);
        LUI: result = {b[15:0], 16'b0};
        default: result = 32'hz;
    endcase

    r = result;
    zero = (result == 32'd0) ? 1'b1 : 1'b0;
    negative = result[31];
    overflow = overflow_flag;
    carry = carry_out;
end

endmodule
