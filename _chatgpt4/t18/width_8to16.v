module width_8to16(
    input        clk,
    input        rst_n,
    input        valid_in,
    input  [7:0] data_in,
    output logic valid_out,
    output logic [15:0] data_out
);

    // Internal registers
    logic [7:0] data_lock;      // Register to hold the first part of the data
    logic latch_enable;         // Flag to indicate latching of the first data half

    // Output logic and intermediate data handling
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all states and outputs
            data_out <= 16'b0;
            valid_out <= 1'b0;
            latch_enable <= 1'b0;
            data_lock <= 8'b0;
        end else begin
            if (valid_in) begin
                if (!latch_enable) begin
                    // Latch the first valid 8-bit data
                    data_lock <= data_in;
                    latch_enable <= 1'b1;
                    valid_out <= 1'b0;  // Output is not yet valid after receiving first data
                end else begin
                    // Second valid data received; concatenate and generate outputs
                    data_out <= {data_lock, data_in};  // First part is in higher bits
                    valid_out <= 1'b1;                 // Output is now valid
                    latch_enable <= 1'b0;              // Reset latch for the next data
                end
            end else begin
                // No valid input, maintain current state
                valid_out <= 1'b0;
            end
        end
    end

endmodule
