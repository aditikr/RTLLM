module parallel2serial(
    input  logic clk,
    input  logic rst_n,
    input  logic [3:0] d,
    output logic valid_out,
    output logic dout
);

    // Internal state and counter
    logic [3:0] data;
    logic [1:0] cnt;  // 2-bit counter to track bits positions

    // Counter register and data shift logic
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data <= 4'b0000;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                cnt <= 2'b00;      // Reset counter
                data <= d;         // Load new data
                valid_out <= 1'b1; // Flag valid output
            end else begin
                cnt <= cnt + 2'b01;       // Increment counter
                data <= {data[2:0], 1'b0}; // Shift data left
                valid_out <= 1'b0;         // Clear valid flag unless first cycle
            end
        end
    end

    // Assign dout to the MSB of data for output
    assign dout = data[3];  // MSB is output on dout

endmodule
