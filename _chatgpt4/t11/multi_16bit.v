module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

// Internal registers
reg [15:0] areg, breg;
reg [31:0] yout_r;
reg [4:0] i; // 5 bits to count from 0 to 16

// Reset and start operations
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        i <= 0;
        done <= 0;
    end else begin
        if (start) begin
            if (i == 0) begin
                // Load the registers with input values
                areg <= ain;
                breg <= bin;
                yout_r <= 0;
                done <= 0;
            end else if (i <= 16) begin
                // Perform shift and accumulate
                if (areg[0]) begin
                    yout_r <= yout_r + (breg << (i - 1));
                end
                // Shift the multiplicand right by 1 bit
                areg <= areg >> 1;
            end
            // Increment the counter
            i <= i + 1;
        end else begin
            // Reset the counter if start is not active
            i <= 0;
            done <= 0;
        end

        // Check if multiplication is done
        if (i == 17) begin
            done <= 1;
            yout <= yout_r;
            i <= 0; // Reset the counter to be ready for a new operation
        end
    end
end

endmodule
