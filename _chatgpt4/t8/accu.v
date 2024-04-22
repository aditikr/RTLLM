module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);
    // Internal registers
    reg [9:0] sum;
    reg [2:0] count;

    // Reset and processing logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            sum <= 0;
            count <= 0;
            valid_out <= 0;
            data_out <= 0;
        end else begin
            // Check if input data is valid
            if (valid_in) begin
                if (count < 3) begin
                    // Accumulate input data
                    sum <= sum + data_in;
                    count <= count + 1;
                    valid_out <= 0;
                end else begin
                    // Complete the accumulation with the fourth input
                    sum <= sum + data_in;
                    data_out <= sum + data_in;
                    valid_out <= 1; // Signal that output is valid
                    // Reset sum and count for the next batch
                    sum <= 0;
                    count <= 0;
                end
            end else if (valid_out) begin
                // Ensure valid_out is high for only one cycle
                valid_out <= 0;
            end
        end
    end
endmodule
