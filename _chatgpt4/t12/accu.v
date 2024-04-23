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
                // When valid_in is high, accumulate the input data
                if (count == 0) begin
                    sum <= data_in;  // Start new accumulation
                end else begin
                    sum <= sum + data_in;  // Continue accumulating
                end

                // Increment the count of valid inputs
                count <= count + 1;

                // Check if four inputs have been accumulated
                if (count == 3) begin
                    data_out <= sum + data_in;  // Output the accumulated sum
                    valid_out <= 1'b1;         // Set output valid signal
                end else begin
                    valid_out <= 1'b0;         // Keep output invalid
                end
            end else begin
                valid_out <= 1'b0;             // Keep output invalid if input not valid
            end

            // Reset count and sum after outputting the result
            if (valid_out) begin
                count <= 2'd0;
                sum <= 10'd0;
            end
        end
    end
endmodule
