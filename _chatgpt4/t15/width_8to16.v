module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

// Internal register to hold the first 8-bit data
reg [7:0] data_lock;
// Flag to indicate whether the first data has been stored
reg flag;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset logic: Clear data_out, valid_out, and internal registers/flags
        data_out <= 16'd0;
        valid_out <= 1'b0;
        data_lock <= 8'd0;
        flag <= 1'b0;
    end else begin
        if (valid_in) begin
            if (!flag) begin
                // Store first valid 8-bit data
                data_lock <= data_in;
                flag <= 1'b1;  // Set the flag to indicate data is locked
                valid_out <= 1'b0;  // No valid output yet
            end else begin
                // We have a second valid 8-bit data
                data_out <= {data_lock, data_in};  // Concatenate and form 16-bit data
                valid_out <= 1'b1;  // Output is now valid
                flag <= 1'b0;  // Reset flag for next pair of inputs
            end
        end else begin
            // If input is not valid, do not update any output or flags
            valid_out <= 1'b0;
        end
    end
end

endmodule
