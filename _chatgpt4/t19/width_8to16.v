module width_8to16 (
    input  logic clk,
    input  logic rst_n,
    input  logic valid_in,
    input  logic [7:0] data_in,
    output logic valid_out,
    output logic [15:0] data_out
);

    // Internal state representation to keep track of data availability
    logic [7:0] data_lock;
    logic lock_valid;

    // Output logic should be blocking to adhere to your requirements
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock <= 8'b0;
            lock_valid <= 1'b0;
            valid_out <= 1'b0;
            data_out <= 16'b0;
        end else begin
            if (valid_in) begin
                if (lock_valid) begin
                    // Output the 16-bit data with the first byte in the high order bits
                    data_out <= {data_lock, data_in};
                    valid_out <= 1'b1;

                    // Reset lock after using the stored data
                    lock_valid <= 1'b0;
                end else begin
                    // Store the first 8-bit data
                    data_lock <= data_in;
                    lock_valid <= 1'b1;
                    valid_out <= 1'b0;
                end
            end else begin
                // No valid input, maintain previous state but flag output as invalid
                valid_out <= 1'b0;
            end
        end
    end
endmodule
