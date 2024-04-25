// 8-bit Full Adder Module
module adder_8bit(
    input  logic [7:0] a,  // 8-bit input operand A
    input  logic [7:0] b,  // 8-bit input operand B
    input  logic Cin,      // Carry-in input
    output logic [7:0] y,  // 8-bit output sum
    output logic Co        // Carry-out output
);
    // Internal signals for carry propagation
    logic [7:0] carry;

    // Calculate sum and carry for each bit
    assign {carry[0], y[0]} = a[0] + b[0] + Cin;
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin : gen_adder
            assign {carry[i], y[i]} = a[i] + b[i] + carry[i-1];
        end
    endgenerate

    // Output the final carry
    assign Co = carry[7];
endmodule

// 16-bit Full Adder Module
module adder_16bit(
    input  logic [15:0] a,  // 16-bit input operand A
    input  logic [15:0] b,  // 16-bit input operand B
    input  logic Cin,       // Carry-in input
    output logic [15:0] y,  // 16-bit output sum
    output logic Co         // Carry-out output
);
    // Internal signals
    logic Co0;  // Carry out from the lower 8 bits

    // Instantiate two 8-bit adders
    adder_8bit lower_adder(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(Co0)        
    );

    adder_8bit upper_adder(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Co0),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule
