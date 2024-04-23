module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

// Internal registers
reg [9:0] sum;
reg [1:0] count;

// Reset and count logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 0;
        count <= 0;
        valid_out <= 0;
        data_out <= 0;
    end else begin
        // On valid input, process data
        if (valid_in) begin
            if (count < 3) begin
                sum <= sum + data_in;    // Accumulate the data
                count <= count + 1;      // Increment count
                valid_out <= 0;          // Keep the output invalid
            end else begin
                sum <= sum + data_in;    // Add the fourth input
                data_out <= sum;         // Set the output data
                valid_out <= 1;          // Output is now valid
                sum <= 0;                // Reset sum for next round
                count <= 0;              // Reset count for next round
            end
        end else begin
            valid_out <= 0;              // Make sure valid_out remains 0 when input is not valid
        end
    end
end

endmodule
