module parallel2serial(
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output reg   dout
);

    reg [2:0] cnt;            // 3-bit counter for bit shifting
    reg [3:0] data;           // Data register to hold the 4-bit input

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'd0;
            valid_out <= 1'b0;
            dout <= 1'b0;
            data <= 4'b0000;
        end else begin
            if (cnt == 3'd3) begin
                // Load new data every 4th clock cycle
                data <= d;
                cnt <= 3'd0;
                valid_out <= 1'b1;  // Output is valid when new data is loaded
                dout <= d[3];       // Output the MSB of the new data
            end else begin
                cnt <= cnt + 1;
                valid_out <= 1'b0;
                dout <= data[2];    // Shift out the next significant bit
                data <= {data[2:0], 1'b0}; // Shift data left, padding with 0
            end
        end
    end

endmodule
