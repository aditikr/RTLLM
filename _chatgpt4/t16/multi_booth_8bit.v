module multi_booth_8bit(
    input        clk,
    input        reset,
    input  [7:0] a,
    input  [7:0] b,
    output [15:0] p,
    output       rdy
);

    reg [15:0] product, multiplicand;
    reg [15:0] multiplier;
    reg [4:0] ctr;
    reg done;
    
    wire [1:0] booth_code;
    assign booth_code = multiplier[1:0];
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplier <= {{8{b[7]}}, b}; // Sign extend the multiplier
            multiplicand <= {{8{a[7]}}, a}; // Sign extend multiplicand
            product <= 16'b0;
            ctr <= 5'b0;
            done <= 1'b0;
        end else begin
            if (!done) begin
                case (booth_code)
                    2'b01, 2'b10: product <= product + multiplicand;   // Equivalent to +a if multiplier bit is 1
                    2'b11, 2'b00: product <= product - multiplicand;   // Equivalent to -a if multiplier bit is 2
                endcase
                multiplicand <= multiplicand << 2; // Double shift for radix-4
                ctr <= ctr + 2;                    // Increment counter by 2 for radix-4
                
                if (ctr >= 16) begin
                    done <= 1'b1;
                end
            end
        end
    end
    
    assign p = product;
    assign rdy = done;
    
endmodule
