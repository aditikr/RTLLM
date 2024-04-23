module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [3:0] data;
reg [1:0] cnt;
reg valid;
reg dout;

// Valid_out output buffer
assign valid_out = valid;

// Sequential logic for data shifting and output
always @(posedge clk) begin
    if (!rst_n) begin
        data <= 4'b0000;
        cnt <= 2'b00;
        valid <= 1'b0;
    end
    else begin
        if (cnt == 2'b11) begin
            // Load new data when all bits have been shifted out
            data <= d;
            cnt <= 2'b00;
            valid <= 1'b1; // Start new cycle, valid data available
        end
        else begin
            // Shift data and increment counter
            data <= {data[2:0], data[3]};
            cnt <= cnt + 1;
            valid <= 1'b0; // Data not valid while shifting
        end
    end
end

// Output logic
always @(posedge clk) begin
    if (valid_out)
        dout <= data[3];  // asign the most significant bit to output
end

endmodule
