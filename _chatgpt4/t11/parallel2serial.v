module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt; // 2-bit counter to track the bit position
    reg [3:0] data; // Register to hold the current data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset the state
            cnt <= 2'b00;
            data <= 4'b0000;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                // Load new data and reset counter
                data <= d;
                cnt <= 2'b00;
                valid_out <= 1'b1; // Valid output available
                dout <= d[3]; // Output MSB
            end else begin
                // Shift data and increment counter
                data <= {data[2:0], 1'b0}; // Shift left
                dout <= data[3]; // Output the next bit
                cnt <= cnt + 1;
                valid_out <= 1'b1; // Continue outputting valid data
            end
        end
    end
endmodule
