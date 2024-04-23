module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

// Internal counter to keep track of how many bits have been shifted in
reg [2:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the count and output data
        cnt <= 0;
        dout_parallel <= 0;
        dout_valid <= 0;
    end 
    else begin
        if (din_valid) begin
            // Shift the serial data into dout_parallel 
            dout_parallel <= (dout_parallel << 1) | din_serial;

            // Increment counter
            cnt <= cnt + 1;

            // Check if we have received 8 bits
            if (cnt == 7) begin
                dout_valid <= 1;  // Set dout_valid high after 8 bits
                cnt <= 0;         // Reset counter
            end else begin
                dout_valid <= 0;
            end 
        end
    end
end

endmodule
