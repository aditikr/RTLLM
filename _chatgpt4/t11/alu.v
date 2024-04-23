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

    // Define operation codes
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

    // Internal signals
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [31:0] result;
    assign zero = (result == 32'b0);

    always @(*) begin
        carry = 0;
        overflow = 0;
        flag = 0;
        case (aluc)
            ADD: begin
                {carry, r} = a + b;
                overflow = (signed_a[31] == signed_b[31]) && (signed_a[31] != r[31]);
            end
            ADDU: begin
                r = a + b;
            end
            SUB: begin
                {carry, r} = a - b;
                overflow = (signed_a[31] != signed_b[31]) && (signed_a[31] != r[31]);
            end
            SUBU: begin
                r = a - b;
            end
            AND: begin
                r = a & b;
            end
            OR: begin
                r = a | b;
            end
            XOR: begin
                r = a ^ b;
            end
            NOR: begin
                r = ~(a | b);
            end
            SLT: begin
                r = (signed_a < signed_b) ? 32'b1 : 32'b0;
                flag = 1;
            end
            SLTU: begin
                r = (a < b) ? 32'b1 : 32'b0;
                flag = 1;
            end
            SLL: begin
                r = b << a[4:0];
            end
            SRL: begin
                r = b >> a[4:0];
            end
            SRA: begin
                r = signed_b >>> a[4:0];
            end
            SLLV: begin
                r = b << a[4:0];
            end
            SRLV: begin
                r = b >> a[4:0];
            end
            SRAV: begin
                r = signed_b >>> a[4:0];
            end
            LUI: begin
                r = {b[15:0], 16'b0};
            end
            default: begin
                r = 32'bz;
            end
        endcase
        negative = r[31];
    end

    assign result = r;

endmodule
