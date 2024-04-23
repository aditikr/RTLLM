module multi_booth_8bit(
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Registers to store the intermediate values
reg signed [15:0] multiplier;
reg signed [15:0] multiplicand;
reg [4:0] ctr; // Use 5-bit counter to count up to 16

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Resetting and initializing values
        p <= 0;
        ctr <= 0;
        rdy <= 0;
        multiplier <= {{8{b[7]}}, b}; // Extend the sign bit for multiplier
        multiplicand <= {{8{a[7]}}, a}; // Extend the sign bit for multiplicand
    end else begin
        if (ctr < 16) begin
            // Perform the main multiplying process
            case ({multiplier[1:0], 1'b0}) // Radix-4 Booth encoding needs 3 bits
                3'b001, 3'b010: begin
                    p <= p + multiplicand;
                end
                3'b011: begin
                    p <= p + (multiplicand << 1); // equivalent to 2 * multiplicand
                end
                3'b100: begin
                    p <= p + (- (multiplicand << 1)); // Add the 2's complement
                end
                3'b101, 3'b110: begin
                    p <= p - multiplicand;
                end
                default: begin
                    // 000 or 111 do nothing
                end
            endcase

            // Shift the registers for next operation
            multiplier <= multiplier >> 2;
            multiplicand <= multiplicand << 2;
            
            // increment the counter
            ctr <= ctr + 2;
        end
        
        // Set the ready flag when done
        if (ctr >= 16) begin
            rdy <= 1;
        end
    end
end

endmodule
