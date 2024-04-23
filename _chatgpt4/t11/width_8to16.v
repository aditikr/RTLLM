module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

    // Internal state to store the first 8-bit data
    reg [7:0] data_lock;
    // Flag to indicate that the first data has been stored
    reg data_stored;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers and outputs
            data_out <= 16'b0;
            valid_out <= 1'b0;
            data_lock <= 8'b0;
            data_stored <= 1'b0;
        end else begin
            if (valid_in) begin
                if (!data_stored) begin
                    // Store the first valid 8-bit data
                    data_lock <= data_in;
                    data_stored <= 1'b1;
                    valid_out <= 1'b0; // Output is not yet valid
                end else begin
                    // Concatenate the stored data and the new data
                    data_out <= {data_lock, data_in};
                    valid_out <= 1'b1; // Output is now valid
                    data_stored <= 1'b0; // Reset the storage flag
                end
            end else begin
                // If input is not valid, maintain the current state
                valid_out <= 1'b0;
            end
        end
    end

endmodule
