module multi_booth_8bit(
    input  logic clk,
    input  logic reset,
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [15:0] p,
    output logic rdy
);

    logic [15:0] multiplier, multiplicand;
    logic [4:0] counter; // 5-bit counter capable of counting from 0 to 16

    // Sign-extend inputs a and b
    logic [15:0] sign_a, sign_b;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sign_a <= {{8{a[7]}}, a};
            sign_b <= {{8{b[7]}}, b};
            multiplier <= 0;
            multiplicand <= 0;
            p <= 0;
            counter <= 0;
            rdy <= 0;
        end else begin
            if (counter == 0) begin
                // Initialize on the first clock cycle after reset
                multiplier <= sign_b;
                multiplicand <= sign_a;
                p <= 0;
                counter <= counter + 1;
                rdy <= 0;
            end else if (counter < 16) begin
                // Check two bits of the multiplier (including the next bit, which might be 0 beyond 15)
                case (multiplier[1:0])
                    2'b01:   p <= p + multiplicand;  // +1 * M
                    2'b10:   p <= p - multiplicand;  // -1 * M
                    2'b11,   // +2 * M
                    2'b00: ; // +0 * M (do nothing)
                endcase

                // Arithmetic shift right by 2 (Radix-4 Booth)
                multiplicand <= multiplicand << 2;
                multiplier  <= {{2{multiplier[15]}}, multiplier[15:2]};
                counter <= counter + 1;  // increment counter to move to the next bit pair
            end else if (counter == 16) begin
                rdy <= 1; // Set ready when multiplication is done
            end
        end
    end

    // Since p is now 16 bits, and a * b multiplied in the worst case is too big
    // It should correctly represent the product of two 8-bit numbers sign-extended to 16 bits
endmodule
