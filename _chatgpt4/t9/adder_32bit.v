`timescale 1ns / 1ps

module testbench_adder_32bit;
    reg [31:0] A, B;
    wire [31:0] S;
    wire C32;

    // Instantiate the 32-bit adder
    adder_32bit uut (
        .A(A),
        .B(B),
        .S(S),
        .C32(C32)
    );

    initial begin
        // Initialize inputs
        A = 0; B = 0;
        #10;

        // Test case 1: Simple addition
        A = 32'h0001_0001; B = 32'h0001_0001;
        #10;

        // Test case 2: Addition with carry-out
        A = 32'hFFFF_FFFF; B = 32'h0000_0001;
        #10;

        // Test case 3: Random values
        A = 32'h1234_5678; B = 32'h8765_4321;
        #10;

        // Test case 4: Full addition
        A = 32'hFFFFFFFF; B = 32'hFFFFFFFF;
        #10;

        // Complete the simulation
        $finish;
    end

    initial begin
        $monitor("Time = %t, A = %h, B = %h, Sum = %h, Carry = %b", $time, A, B, S, C32);
    end
endmodule
