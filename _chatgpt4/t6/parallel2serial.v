
module parallel2serial(
    input clk,          // Clock signal
    input rst_n,        // Active low reset
    input [3:0] d,      // 4-bit parallel data input
    output reg valid_out, // Output valid signal
    output reg dout     // Serial data output
);

    reg [1:0] cnt;      // 2-bit counter to track the bit position
    reg [3:0] data;     // Register to hold the current data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            cnt <= 2'b00;
            valid_out <= 1'b0;
            dout <= 1'b0;
            data <= 4'b0000;
        end else begin
            if (cnt == 2'b11) begin
                // Last bit has been output, load new data
                data <= d;
                cnt <= 2'b00;
                valid_out <= 1'b1; // Valid output available
                dout <= d[3];      // Output MSB of new data
            end else begin
                // Shift data and output next bit
                data <= {data[2:0], 1'b0}; // Shift left
                cnt <= cnt + 1'b1;
                valid_out <= 1'b1; // Continue to output valid data
                dout <= data[3];   // Output the next bit
            end
        end
    end
endmodule
