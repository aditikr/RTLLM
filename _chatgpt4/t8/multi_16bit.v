module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);
    // Internal registers for holding values and computation
    reg [15:0] areg, breg;
    reg [31:0] yout_r;
    reg [4:0] i; // 5 bits to count from 0 to 16

    // Main sequential logic for multiplication and control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers and output
            areg <= 0;
            breg <= 0;
            yout_r <= 0;
            i <= 0;
            done <= 0;
        end else if (start) begin
            if (i == 0) begin
                // Load inputs into registers at the start of multiplication
                areg <= ain;
                breg <= bin;
                yout_r <= 0;
            end
            if (i < 16) begin
                // Perform shift and accumulate if the corresponding bit in areg is set
                if (areg[i]) begin
                    yout_r <= yout_r + (breg << i);
                end
                i <= i + 1;
            end else if (i == 16) begin
                // Indicate completion and prevent further accumulation
                done <= 1;
                i <= i + 1; // Increment i to 17 to stop operations
            end
        end else begin
            // Reset i and done if start is not active
            i <= 0;
            done <= 0;
        end
    end

    // Assign the computed product to the output
    always @(posedge clk) begin
        if (done) begin
            yout <= yout_r;
        end
    end
endmodule
