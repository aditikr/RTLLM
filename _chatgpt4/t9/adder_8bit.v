module testbench;
    reg [7:0] a, b;
    reg cin;
    wire [7:0] sum;
    wire cout;

    // Instantiate the 8-bit adder
    adder_8bit uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        // Test vector 1
        a = 8'h55;  // 01010101
        b = 8'hAA;  // 10101010
        cin = 0;
        #10;

        // Test vector 2
        a = 8'hFF;  // 11111111
        b = 8'h01;  // 00000001
        cin = 1;
        #10;

        // Add more test vectors as needed
    end
endmodule
