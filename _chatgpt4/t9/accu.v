module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);
    // Internal registers for sum and count
    reg [9:0] sum;  // To store the accumulated sum, 10 bits to handle overflow
    reg [1:0] count;  // To count the number of valid inputs received

    // Main logic block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset logic
            sum <= 0;
            count <= 0;
            valid_out <= 0;
            data_out <= 0;
        end else begin
            if (valid_in) begin
                // When valid_in is high, accumulate the data
                if (count < 3) begin
                    // Accumulate and increment count
                    sum <= sum + data_in;
                    count <= count + 1;
                    valid_out <= 0;  // Keep valid_out low until 4 inputs are accumulated
                end else begin
                    // Fourth input, produce output
                    sum <= sum + data_in;
                    data_out <= sum;  // Output the accumulated result
                    valid_out <= 1;  // Signal that the output is valid
                    sum <= 0;  // Reset sum for next accumulation
                    count <= 0;  // Reset count
                end
            end else begin
                // When valid_in is low, maintain the current state but reset valid_out
                valid_out <= 0;
            end
        end
    end
endmodule
