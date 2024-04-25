module width_8to16(
    input  logic clk,
    input  logic rst_n,
    input  logic valid_in,
    input  logic [7:0] data_in,
    output logic valid_out,
    output logic [15:0] data_out
);

    logic [7:0] data_lock;
    logic data_ready; // Indicates that data_lock holds valid data
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 16'b0;
            data_lock <= 8'b0;
            valid_out <= 1'b0;
            data_ready <= 1'b0;
        end else begin
            if (valid_in) begin
                if (data_ready) begin
                    // Data_ready is true, meaning we have the first part stored
                    data_out <= {data_lock, data_in}; // Combine and output
                    valid_out <= 1'b1;
                    data_ready <= 1'b0; // Reset data_ready for next byte pair
                end else begin
                    // First byte comes in, store it and wait for next
                    data_lock <= data_in;
                    data_ready <= 1'b1;
                    valid_out <= 1'b0; // No valid output until we get the second byte
                end
            end else begin
                // If no valid input, do not output valid data
                valid_out <= 1'b0;
            end
        end
    end

endmodule
