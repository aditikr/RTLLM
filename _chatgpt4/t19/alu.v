module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output wire        carry,
    output wire        negative,
    output wire        overflow,
    output reg         flag
);

    // Operation codes for ALU control
    localparam ADD  = 6'b100000;
    localparam ADDU = 6'b100001;
    localparam SUB  = 6'b100010;
    localparam SUBU = 6'b100011;
    localparam AND  = 6'b100100;
    localparam OR   = 6'b100101;
    localparam XOR  = 6'b100110;
    localparam NOR  = 6'b100111;
    localparam SLT  = 6'b101010;
    localparam SLTU = 6'b101011;
    localparam SLL  = 6'b000000;
    localparam SRL  = 6'b000010;
    localparam SRA  = 6'b000011;
    localparam SLLV = 6'b000100;
    localparam SRLV = 6'b000110;
    localparam SRAV = 6'b000111;
    localparam LUI  = 6'b001111;

    reg [31:0] res;
    reg c, o, n, z, f;

    always @(*) begin
        res = 32'bz;  // Default high impedance except when matched
        c = 0;
        o = 0;
        n = 0;
        z = 0;
        f = 0;
        case (aluc)
            ADD: {c, res} = a + b;
            ADDU: res = a + b;
            SUB: {c, res} = a - b;
            SUBU: res = a - b;
            AND: res = a & b;
            OR:  res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: begin
                res = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
                f = res[0];
            end
            SLTU: begin
                res = (a < b) ? 32'd1 : 32'd0;
                f = res[0];
            end
            SLL:  res = b << a[4:0];
            SRL:  res = b >> a[4:0];
            SRA:  res = $signed(b) >>> a[4:0];
            SLLV: res = b << a[4:0];
            SRLV: res = b >> a[4:0];
            SRAV: res = $signed(b) >>> a[4:0];
            LUI:  res = {b[15:0], 16'h0000};
            default: res = 32'bz;
        endcase
        r = res;
        z = (res == 32'd0);
        n = res[31];
        o = (((aluc == ADD || aluc == SUB) && (a[31] == b[31]) && (res[31] != a[31])) ? 1'b1 : 1'b0);
    end

    assign zero = z;
    assign carry = c;
    assign negative = n;
    assign overflow = o;

endmodule
