module accu (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    input wire valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);
    // Internal variables
    reg [9:0] sum;
    reg [2:0] count;  // Count the number of valid data inputs (up to 4)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Synchronous reset
            sum <= 10'd0;
            count <= 3'd0;
            valid_out <= 1'b0;
            data_out <= 10'd0;
        end else begin
            if (valid_in) begin
                if (count == 3'd0) begin
                    // First input after reset or after processing 4 inputs
                    sum <= data_in;  // Start new accumulation
                end else begin
                    // Accumulate inputs
                    sum <= sum + data_in;
                end
                
                // Increment count or reset if it reaches 4
                if (count == 3'd3) begin
                    // Reached four valid inputs, prepare output
                    data_out <= sum + data_in;  // Complete the accumulation with the fourth input
                    valid_out <= 1'b1;
                    count <= 3'd0;  // Reset count for next batch of inputs
                end else begin
                    // Still expecting more inputs
                    count <= count + 1'b1;
                    valid_out <= 1'b0;  // Ensure valid_out is low while counting
                end
            end else begin
                // Maintain previous state when valid_in is not asserted
                valid_out <= 1'b0;
            end
        end
    end
endmodule
