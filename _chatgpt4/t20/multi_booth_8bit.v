module multi_booth_8bit (
    input  logic clk,
    input  logic reset,
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [15:0] p,
    output logic rdy
);

    // Internal registers and wires
    logic [15:0] multiplicand, multiplier;
    logic [4:0] ctr; // 5-bit counter
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign extension and initialization
            multiplicand <= {{8{b[7]}}, b};
            multiplier   <= {{8{a[7]}}, a};
            p <= 16'b0;
            ctr <= 5'b0;
            rdy <= 0;
        end else begin
            if (ctr < 16) begin
                // Booth Encoding Checks and Multiplication Action
                case (multiplier[1:0])
                    2'b01: p <= p + multiplicand; // +M
                    2'b10: p <= p - multiplicand; // -M
                    default: p <= p; // No action for 00 or 11
                endcase
                
                // Arithmetic shift right (ASR) for both multiplier and product
                {p, multiplier} <= {p[15], p, multiplier} >> 1;
                ctr <= ctr + 1;
            end else begin
                rdy <= 1; // Set ready after operations complete
            end
        end
    end

endmodule
