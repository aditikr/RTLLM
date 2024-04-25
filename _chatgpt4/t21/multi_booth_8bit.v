module multi_booth_8bit(
    input        clk,
    input        reset,
    input  [7:0] a,
    input  [7:0] b,
    output [15:0] p,
    output       rdy
);

    // Internal registers
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [4:0]  ctr;  // 5 bits, enough to count 0-15
    reg [15:0] product;
    reg        ready;
    
    // Declare output connections
    assign p = product;
    assign rdy = ready;

    // Main process for multiplication
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Load the initial values into registers
            multiplicand <= { {8{b[7]}}, b };  // Sign extend to 16 bits
            multiplier <= { {8{a[7]}}, a };    // Sign extend to 16 bits
            product <= 0;
            ctr <= 0;
            ready <= 0;
        end else begin
            if (ctr < 16) begin
                // Booth's Radix-4 implementation
                case (multiplier[1:0])
                    2'b01: product = product + multiplicand;
                    2'b10: product = product - multiplicand;
                    default: product = product;
                endcase

                // Shift operation as required by Booth's algorithm
                multiplicand = multiplicand << 2;  // Shift left by 2 because it's radix-4
                multiplier = multiplier >> 2;  // Logical shift right by 2
                ctr = ctr + 2;  // Increment counter by 2 each time for Radix-4
            end else if (ctr >= 16 && !ready) begin
                ready <= 1;  // Set ready when multiplication is complete
            end
        end
    end

endmodule
