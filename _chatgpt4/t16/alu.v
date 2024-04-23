module alu (
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output [31:0] r,
    output        zero,
    output        carry,
    output        negative,
    output        overflow,
    output reg    flag
);

    reg [31:0] result;
    reg tmp_carry;
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;

    // ALU control signals (opcodes)
    localparam ADD  = 6'b100000,
               ADDU = 6'b100001,
               SUB  = 6'b100010,
               SUBU = 6'b100011,
               AND  = 6'b100100,
               OR   = 6'b100101,
               XOR  = 6'b100110,
               NOR  = 6'b100111,
               SLT  = 6'b101010,
               SLTU = 6'b101011,
               SLL  = 6'b000000,
               SRL  = 6'b000010,
               SRA  = 6'b000011,
               SLLV = 6'b000100,
               SRLV = 6'b000110,
               SRAV = 6'b000111,
               LUI  = 6'b001111;

    // ALU Operations
    always @(*) begin
        case (aluc)
            ADD:  {tmp_carry, result} = {a[31], a} + {b[31], b};
            ADDU: result = a + b;
            SUB:  {tmp_carry, result} = {a[31], a} - {b[31], b};
            SUBU: result = a - b;
            AND:  result = a & b;
            OR:   result = a | b;
            XOR:  result = a ^ b;
            NOR:  result = ~(a | b);
            SLT:  result = signed_a < signed_b;
            SLTU: result = a < b;
            SLL:  result = b << a[4:0];
            SRL:  result = b >> a[4:0];
            SRA:  result = signed_b >>> a[4:0];
            SLLV: result = b << a[4:0];
            SRLV: result = b >> a[4:0];
            SRAV: result = signed_b >>> a[4:0];
            LUI:  result = {b[15:0], 16'b0};
            default: result = 32'bx;
        endcase

        // Set flag for SLT and SLTU commands
        flag = (aluc == SLT || aluc == SLTU) ? (result != 0) : 1'b0;
    end

    // Assigning outputs
    assign r = result;
    assign zero = (result == 0);
    assign negative = result[31];
    assign overflow = (aluc == ADD || aluc == SUB) && (tmp_carry != result[31]);
    assign carry = (aluc == ADDU || aluc == ADD || aluc == SUBU || aluc == SUB) ? tmp_carry : 1'b0;

endmodule
