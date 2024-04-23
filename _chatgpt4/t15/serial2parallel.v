module serial2parallel(
    input wire clk,         // Clock signal
    input wire rst_n,       // Reset signal (active low)
    input wire din_serial,  // Serial input data
    input wire din_valid,   // Validity signal for input data
    output reg [7:0] dout_parallel, // Parallel output data (8 bits wide)
    output reg dout_valid   // Validity signal for the output data
);

reg [2:0] cnt; // 3-bit counter to count up to 8 bits

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset logic
        cnt <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end
    else begin
        if (din_valid) begin
            if (cnt < 3'd7) begin
                // Shift in the serial data into dout_parallel
                dout_parallel <= {din_serial, dout_parallel[7:1]};
                cnt <= cnt + 1;
                dout_valid <= 1'b0; // dout_valid remains 0 until all 8 bits are received
            end 
            else begin
                // Last bit received, output the complete byte
                dout_parallel <= {din_serial, dout_parallel[7:1]};
                dout_valid <= 1'b1; // Signal that valid parallel data is available
                cnt <= 3'b000; // Reset the counter for the next sequence
            end
        end
        else if (dout_valid) begin
            // Reset dout_valid if it was set in the previous cycle
            dout_valid <= 1'b0;
        end
    end
end

endmodule
