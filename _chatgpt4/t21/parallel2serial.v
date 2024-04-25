module parallel2serial(
    input  logic clk,
    input  logic rst_n,
    input  logic [3:0] d,
    output logic valid_out,
    output logic dout
);

    // Data register to hold the parallel input
    logic [3:0] data;

    // Counter to keep track of bit position
    logic [1:0] cnt;

    // Control the loading of data and the output generation
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            data <= 4'b0;
            valid_out <= 0;
        end else begin
            if (cnt == 3) begin
                data <= d;        // Load the new parallel input
                cnt <= 0;         // Reset counter
                valid_out <= 1;   // Indicate valid output start
            end else begin
                cnt <= cnt + 1;   // Increment counter
                data <= {data[2:0], 1'b0};  // Shift left
                valid_out <= 0;   // Clear valid flag
            end
        end
    end

    // Serial output is the MSB of the data register
    assign dout = data[3];

endmodule
