module multi_16bit(
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // Internal registers and wires
    reg [15:0] areg, breg; // Registers to hold inputs
    reg [31:0] yout_r;     // Register to hold the intermediate product
    reg [4:0] i;           // Counter for bit position in the multiplier
    reg done_r;            // Register to hold the done signal

    // Reset and Start Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 0;
            yout_r <= 0;
            done_r <= 0;
        end else if (start) begin
            if (i == 0) begin
                areg <= ain;
                breg <= bin;
                yout_r <= 0;
            end
            i <= i + 1;
        end else begin
            i <= 0;
        end
    end

    // Shift and Accumulate Logic
    always @(posedge clk) begin
        if (start && i > 0 && i <= 16) begin
            if (areg[i-1]) begin
                yout_r <= yout_r + (breg << (i-1));
            end
        end
        if (i == 16) begin
            done_r <= 1;
        end else if (i == 17) begin
            done_r <= 0;
            i <= 0; // Reset the counter after completion
        end
    end

    // Output Assignment
    assign yout = yout_r;
    assign done = done_r;

endmodule
