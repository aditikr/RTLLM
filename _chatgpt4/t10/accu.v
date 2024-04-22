module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Internal variables
    reg [9:0] sum;
    reg [1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            sum <= 10'd0;
            count <= 2'd0;
            valid_out <= 1'b0;
            data_out <= 10'd0;
        end else begin
            if (valid_in) begin
                // Accumulate data when valid_in is high
                if (count == 2'd3) begin
                    // On the fourth valid input, output the sum
                    sum <= sum + data_in;
                    data_out <= sum + data_in; // Output the final sum
                    valid_out <= 1'b1;        // Set valid_out high for one cycle
                    count <= 2'd0;            // Reset count
                    sum <= 10'd0;             // Reset sum
                end else begin
                    // Not yet the fourth input, accumulate the sum
                    sum <= sum + data_in;
                    count <= count + 1'b1;
                    valid_out <= 1'b0;        // Ensure valid_out is low
                end
            end else begin
                // No valid input, ensure output is not valid
                valid_out <= 1'b0;
            end
        end
    end

endmodule
