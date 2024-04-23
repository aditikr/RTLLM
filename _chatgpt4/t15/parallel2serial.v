module parallel2serial (
    input clk,            // Clock signal
    input rst_n,          // Active low reset
    input [3:0] d,        // 4-bit parallel data input
    output reg valid_out, // Output valid signal
    output reg dout       // Serial output data
);

    // Counter to track the number of bits shifted out
    reg [1:0] cnt;
    // Data register to hold the current bit to be transmitted
    reg [3:0] data;

    // This always block handles the state transitions and outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset the state
            cnt <= 2'b11; // Set to 3 so that it wraps around to 0 when the module is reset
            data <= 4'b0000;
            valid_out <= 0;
            dout <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                // Load new data and reset the counter on the fourth cycle
                data <= d;       // Load the new parallel data
                cnt <= 2'b00;    // Reset the counter
                dout <= d[3];    // Output the MSB
                valid_out <= 1;  // Set valid_out high as output is available
            end else begin
                // Shift out the next bit
                data <= {data[2:0], 1'b0}; // Shift data left
                dout <= data[3];           // Output the next MSB
                cnt <= cnt + 1'b1;         // Increment the bit counter
                valid_out <= 1;            // Maintain output as valid
            end
        end
    end
endmodule
