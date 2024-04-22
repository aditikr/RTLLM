
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
                end

                if (i < 16) begin
                    // Perform shift and accumulate
                    if (areg[i]) begin
                        yout_r <= yout_r + (breg << i);
                    end
                    i <= i + 1;
                end else if (i == 16) begin
                    // Finalize the multiplication
                    yout <= yout_r;
                    done <= 1;
                    i <= i + 1; // Move to completion state
                end else begin
                    // Reset i to 0 to be ready for a new start
                    i <= 0;
                end
            end else begin
                // If not started, reset i and done
                i <= 0;
                done <= 0;
            end
        end
    end

endmodule
