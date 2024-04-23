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
            sum <= 0;
            count <= 0;
            valid_out <= 0;
            data_out <= 0;
        end else begin
            if (valid_in) begin
                if (count < 3) begin
                    // Accumulate data and increment count
                    sum <= sum + data_in;
                    count <= count + 1;
                    valid_out <= 0;  // Output not valid yet
                end else begin
                    // Last data for accumulation
                    sum <= sum + data_in;
                    data_out <= sum;  // Output the accumulated sum
                    valid_out <= 1;   // Output is now valid
                    sum <= 0;         // Reset sum for next accumulation
                    count <= 0;       // Reset count
                end
            end else begin
                // No valid input, maintain current state but ensure output is not valid
                valid_out <= 0;
            end
        end
    end

endmodule
