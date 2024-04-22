
module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

// Internal variables
reg [9:0] sum;          // To store the sum of four inputs
reg [1:0] count;        // To count the number of valid inputs

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        sum <= 0;
        count <= 0;
        data_out <= 0;
        valid_out <= 0;
    end else begin
        if (valid_in) begin
            // When valid_in is high, process the input data
            if (count < 3) begin
                // Accumulate data until we have four inputs
                sum <= sum + data_in;
                count <= count + 1;
                valid_out <= 0;  // Output is not yet valid
            end else begin
                // When we have four inputs, output the sum
                sum <= sum + data_in;
                data_out <= sum;
                valid_out <= 1;  // Output is valid for one cycle
                // Reset sum and count for the next accumulation
                sum <= 0;
                count <= 0;
            end
        end else begin
            // When valid_in is low, ensure valid_out is also low
            valid_out <= 0;
        end
    end
end

endmodule
