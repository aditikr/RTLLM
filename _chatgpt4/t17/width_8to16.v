module width_8to16(
    input        clk,
    input        rst_n,
    input        valid_in,
    input  [7:0] data_in,
    output logic valid_out,
    output logic [15:0] data_out
);

    // Internal states for storing the first half of the data
    logic [7:0] data_lock;
    logic       data_ready;

    // State register and data concatenation logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock   <= 8'b0;
            data_ready  <= 1'b0;
            data_out    <= 16'b0;
            valid_out   <= 1'b0;
        end else begin
            if (valid_in) begin
                if (!data_ready) begin
                    // Store the first 8-bit data and wait for the next 8-bit data
                    data_lock   <= data_in;
                    data_ready  <= 1'b1;
                    valid_out   <= 1'b0;
                end else begin
                    // Data ready and new data_valid received
                    data_out    <= {data_lock, data_in};  // Concatenate old and new data
                    valid_out   <= 1'b1;                  // Output is now valid
                    data_ready  <= 1'b0;                  // Reset the data ready state
                end
            end else begin
                valid_out   <= 1'b0;                      // No valid input, no valid output
            end
        end
    end

endmodule
