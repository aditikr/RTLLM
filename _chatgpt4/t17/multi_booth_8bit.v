module multi_booth_8bit(
    input logic clk,
    input logic reset,
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [15:0] p,
    output logic rdy
);

    // Internal registers for computation
    logic [15:0] multiplier, multiplicand;
    logic [4:0] ctr; // 5-bit counter for iterations

    // State machine control signal
    logic working;

    // Initialization and operation handling
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign extend the input values, initialize product and counter
            multiplier <= {{8{b[7]}}, b};  // Sign extension for 2's complement numbers
            multiplicand <= {{8{a[7]}}, a};
            p <= 0;
            ctr <= 0;
            working <= 1;
            rdy <= 0;
        end else if (working) begin
            // Booth encoding and multiplication algorithm
            case (multiplier[1:0])
                2'b01: p <= p + multiplicand;
                2'b10: p <= p - multiplicand;
                default: p <= p;
            endcase

            // Arithmetic shift right for 'multiplier' and 'multiplicand'
            multiplicand <= multiplicand << 1;
            multiplier <= {multiplier[15], multiplier[15:1]};  // Preserve sign bit for ASR

            // Increment counter and check for the completion
            ctr <= ctr + 1;
            if (ctr == 15) begin
                working <= 0;
                rdy <= 1; // Signal that the computation is done
            end
        end
    end

endmodule
