`timescale 1ns / 1ps

module radix2_div_tb;

parameter DATAWIDTH = 8;

// Inputs
reg clk;
reg rstn;
reg en;
reg [DATAWIDTH-1:0] dividend;
reg [DATAWIDTH-1:0] divisor;

// Outputs
wire ready;
wire [DATAWIDTH-1:0] quotient;
wire [DATAWIDTH-1:0] remainder;
wire vld_out;

// Instantiate the Unit Under Test (UUT)
radix2_div #(.DATAWIDTH(DATAWIDTH)) uut (
    .clk(clk),
    .rstn(rstn),
    .en(en),
    .dividend(dividend),
    .divisor(divisor),
    .ready(ready),
    .quotient(quotient),
    .remainder(remainder),
    .vld_out(vld_out)
);

initial begin
    // Initialize Inputs
    clk = 0;
    rstn = 0;
    en = 0;
    dividend = 0;
    divisor = 0;

    // Wait 100 ns for global reset to finish
    #100;
    rstn = 1;
    en = 1;
    dividend = 123;
    divisor = 10;

    // Wait for ready signal
    wait (ready == 1);
    #10;
    en = 0;

    // Add more test cases here
end

// Clock generation
always #5 clk = ~clk;

endmodule
