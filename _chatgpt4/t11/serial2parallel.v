module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // Internal counter to track the number of bits received
    reg [2:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset the counter and outputs
            cnt <= 3'b000;
            dout_parallel <= 8'b00000000;
            dout_valid <= 1'b0;
        end else begin
            if (din_valid) begin
                // Shift the serial data into the parallel output register
                dout_parallel <= {dout_parallel[6:0], din_serial};

                // Increment the counter
                cnt <= cnt + 1;

                // Check if 8 bits have been received
                if (cnt == 3'b111) begin
                    // Set the valid output high and reset the counter
                    dout_valid <= 1'b1;
                    cnt <= 3'b000;
                end else begin
                    // Keep the valid output low until 8 bits are received
                    dout_valid <= 1'b0;
                end
            end else begin
                // If din_valid is not high, do not count or shift
                dout_valid <= 1'b0;
            end
        end
    end

endmodule
