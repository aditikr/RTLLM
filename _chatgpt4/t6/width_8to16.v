
module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

    // Internal state to store the first data input
    reg [7:0] data_lock;
    // Flag to indicate that the first data has been received
    reg data_received;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers and output
            data_out <= 16'b0;
            valid_out <= 1'b0;
            data_lock <= 8'b0;
            data_received <= 1'b0;
        end else begin
            if (valid_in) begin
                if (!data_received) begin
                    // Store the first valid data input
                    data_lock <= data_in;
                    data_received <= 1'b1;
                    valid_out <= 1'b0; // Output is not yet valid
                end else begin
                    // Second valid data received, generate output
                    data_out <= {data_lock, data_in}; // Concatenate first and second data
                    valid_out <= 1'b1; // Output is now valid
                    data_received <= 1'b0; // Reset the data received flag
                end
            end else begin
                // If no valid input, maintain the current state
                valid_out <= 1'b0;
            end
        end
    end

endmodule
