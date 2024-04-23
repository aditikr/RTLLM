module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);
    // Defining operation parameters
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

    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [31:0] unsigned_a = a;
    wire [31:0] unsigned_b = b;

    // Set the outputs based on the computation in 'always' block
    assign zero = (r == 0);

    always @(*) begin
        flag = 0;
        carry = 0;
        overflow = 0;

        case (aluc)
            ADD: begin
                {carry, r} = signed_a + signed_b;
                overflow = (signed_a[31] == signed_b[31]) && (signed_a[31] != r[31]);
            end
            ADDU: begin
                {carry, r} = unsigned_a + unsigned_b;
            end
            SUB: begin
                {carry, r} = signed_a - signed_b;
                overflow = (signed_a[31] != signed_b[31]) && (signed_a[31] != r[31]);
            end
            SUBU: begin
                {carry, r} = unsigned_a - unsigned_b;
            end
            AND: r = a & b;
            OR: r = a | b;
            XOR: r = a ^ b;
            NOR: r = ~(a | b);
            SLT: begin
                r = (signed_a < signed_b) ? 32'b1 : 32'b0;
                flag = 1;
            end
            SLTU: begin
                r = (unsigned_a < unsigned_b) ? 32'b1 : 32'b0;
                flag = 1;
            end
            SLL: r = b << a[4:0];
            SRL: r = b >> a[4:0];
            SRA: r = signed_b >>> a[4:0];
            SLLV: r = b << a[4:0];
            SRLV: r = b >> a[4:0];
            SRAV: r = signed_b >>> a[4:0];
            LUI: r = {b[15:0], 16'b0};
            default: r = 32'bx; // high-impedance state on unknown operation
        endcase
        
        negative = r[31];
    end
endmodule
