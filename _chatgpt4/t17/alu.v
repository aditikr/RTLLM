module alu (
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

    // Opcode Parameters
    parameter ADD = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND = 6'b100100;
    parameter OR = 6'b100101;
    parameter XOR = 6'b100110;
    parameter NOR = 6'b100111;
    parameter SLT = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL = 6'b000000;
    parameter SRL = 6'b000010;
    parameter SRA = 6'b000011;
    parameter SLLV = 6'b000100;
    parameter SRLV = 6'b000110;
    parameter SRAV = 6'b000111;
    parameter LUI = 6'b001111;

    integer s_a; // Signed version of a
    integer s_b; // Signed version of b
    integer s_r; // Signed result

    always @(*) begin
        s_a = a;  // treat a as signed
        s_b = b;  // treat b as signed
        
        // Initialize outputs
        zero = 0;
        carry = 0;
        overflow = 0;
        negative = 0;
        flag = 0;
        
        case (aluc)
            ADD: begin
                s_r = s_a + s_b;
                r = s_r;
                overflow = (s_a[31] == s_b[31]) && (s_r[31] != s_a[31]);
            end
            ADDU: begin
                r = a + b;
                carry = r < a;
            end
            SUB: begin
                s_r = s_a - s_b;
                r = s_r;
                overflow = (s_a[31] != s_b[31]) && (s_r[31] != s_a[31]);
            end
            SUBU: begin
                r = a - b;
                carry = r > a;
            end
            AND: r = a & b;
            OR: r = a | b;
            XOR: r = a ^ b;
            NOR: r = ~(a | b);
            SLT: begin
                s_r = (s_a < s_b) ? 1 : 0;
                r = s_r;
                flag = 1;
            end
            SLTU: begin
                r = (a < b) ? 1 : 0;
                flag = 1;
            end
            SLL: r = b << a[4:0];
            SRL: r = b >> a[4:0];
            SRA: r = s_b >>> a[4:0];
            SLLV: r = b << a;
            SRLV: r = b >> a;
            SRAV: r = s_b >>> a;
            LUI: r = b << 16;
            default: r = 32'bz; // undefined operation
        endcase
        
        // Set output flags
        zero = (r == 0);
        negative = r[31];
    end
endmodule
