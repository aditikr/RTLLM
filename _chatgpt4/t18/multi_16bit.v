module multi_16bit(
    input        clk,
    input        rst_n,
    input        start,
    input  [15:0] ain,
    input  [15:0] bin,
    output [31:0] yout,
    output       done
);

    reg [31:0] yout_r = 0;       // Register to hold the product
    reg [4:0]  i = 0;            // Shift count, uses 5 bits as 16 ranges from 0-15 and one more for completion state
    reg [31:0] p = 0;            // Accumulator register
    reg [15:0] breg;             // Register to hold the shifted multiplier
    reg done_r = 0;              // Register to hold the done signal

    // Applying system reset or progressing the multiplication
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 0;
            p <= 0;
            done_r <= 0;
            yout_r <= 0;
        end else begin
            if (start) begin
                if (i == 0) begin
                    breg <= bin;  // Capture the multiplier
                    p <= 0;       // Reset product accumulation
                end

                // Check if we're in the valid range of multiplication steps
                if (i < 16) begin
                    // Shift and add if the corresponding bit in multiplicand is 1
                    if (ain[i])
                        p <= p + (breg << i);
                end

                // Increment i or complete operation
                if (i == 16) begin
                    yout_r <= p;   // Assign accumulated product
                    done_r <= 1;   // Set done signal after last accumulation step
                end else begin
                    done_r <= 0;
                end

                if (i <= 16) begin
                    i <= i + 1;  // Increment till we reach the end condition
                end
            end else if (!start) begin
                i <= 0;          // Reset when start is no longer asserted
                done_r <= 0;
            end
        end
    end

    // Assign outputs to output ports
    assign yout = yout_r;
    assign done = done_r;

endmodule
