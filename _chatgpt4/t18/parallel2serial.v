module parallel2serial(
    input  logic        clk,
    input  logic        rst_n,
    input  logic [3:0]  d,
    output logic        valid_out,
    output logic        dout
);

    // State encoding and tracking
    logic [3:0] data;    // Register to hold the parallel data for shifting
    logic [1:0] cnt;     // Counter for tracking the bit position

    // Sequential circuitry to manage the shifting and counting process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;            // Reset the counter
            data <= 4'b0000;     // Clear the data register
            valid_out <= 0;      // Clear the valid output
        end else begin
            if (cnt == 3) begin
                cnt <= 0;         // Reset the counter
                data <= d;        // Load new data from input
                valid_out <= 1;   // Indicate valid data is now outputting
            end else begin
                cnt <= cnt + 1;   // Increment the counter
                data <= {data[2:0], 1'b0}; // Shift left and pad with 0
                valid_out <= 0;   // Clear the valid output unless it's the first bit
            end
        end
    end

    // Continuous assignment for serial data output
    assign dout = data[3]; // MSB is shifted out first

endmodule
