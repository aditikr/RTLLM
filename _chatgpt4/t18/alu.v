module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output wire        negative,
    output reg         overflow,
    output reg         flag
);

    // Opcode parameters
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
    reg [31:0] res;
    reg signed [32:0] temp; // Extended bit for carry and overflow detection

    // Compute result
    always @* begin
        carry = 0;
        overflow = 0;
        flag = 0;  // Default flag state

        case (aluc)
            ADD: begin
                temp = $signed(a) + $signed(b);
                r = temp[31:0];
                carry = temp[32];
                overflow = (a[31] == b[31]) && (r[31] != a[31]);
            end
            ADDU: begin
                r = a + b;
                carry = (r < a);
            end
            SUB, SUBU: begin
                temp = $signed(a) - $signed(b);
                r = temp[31:0];
                carry = !temp[32];
                if (aluc == SUB) overflow = (a[31] != b[31]) && (r[31] != a[31]);
            end
            AND: r = a & b;
            OR:  r = a | b;
            XOR: r = a ^ b;
            NOR: r = ~(a | b);
            SLT: begin
                r = $signed(a) < $signed(b);
                flag = r;
            end
            SLTU: begin
                r = a < b;
                flag = r;
            end
            SLL: r = b << a[4:0];
            SRL: r = b >> a[4:0];
            SRA: r = $signed(b) >>> a[4:0];
            SLLV: r = b << (a & 32'h1F);
            SRLV: r = b >> (a & 32'h1F);
            SRAV: r = $signed(b) >>> (a & 32'h1F);
            LUI: r = {b[15:0], 16'h0000};
            default: r = 32'bz;  // Undefined operation
        endcase
    end

    // Output signals
    assign zero = (r == 0);
    assign negative = r[31];

endmodule
