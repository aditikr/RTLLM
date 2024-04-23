module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

// Internal Registers
reg [15:0] areg, breg;
reg [31:0] yout_r;
reg [4:0] i; // Shift count register (0 to 16)
reg done_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers and outputs
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        i <= 0;
        done_r <= 0;
        done <= 0;
        yout <= 0;
    end else begin
        // Check if start signal is active
        if (start) begin
            if (i == 0) begin
                // Load the registers with ain and bin at the beginning
                areg <= ain;
                breg <= bin;
                yout_r <= 0;
            end else if (i <= 16) begin
                // Perform shift and accumulate
                if(areg[i-1] == 1'b1) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
            end

            // Increment i until 16; then reset on the next clock cycle
            if (i < 17) begin
                i <= i + 1;
            end
            
            // Manage completion flag
            if (i == 16) begin
                done_r <= 1'b1;
            end else if (i == 17) begin
                done_r <= 1'b0;
                i <= 0; // Reset i for the next multiplication cycle
            end
        end else begin
            // Reset i when start is not active
            i <= 0;
        end

        // Update output registers
        done <= done_r;
        yout <= yout_r;
    end
end

endmodule
