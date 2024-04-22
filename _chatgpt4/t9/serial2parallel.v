module serial2parallel(
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // Internal 4-bit counter
    reg [3:0] cnt;

    // Main logic block
    always @(posedge clk) begin
        if (!rst_n) begin
            // Reset logic
            cnt <= 4'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end else begin
            if (din_valid) begin
                // Shift the serial data into dout_parallel
                dout_parallel <= (dout_parallel << 1) | din_serial;
                cnt <= cnt + 1'b1;

                // Check if 8 bits have been received
                if (cnt == 4'd7) begin
                    dout_valid <= 1'b1;
                    cnt <= 4'b0;  // Reset counter for next data
                end else begin
                    dout_valid <= 1'b0;
                end
            end
        end
    end

endmodule
