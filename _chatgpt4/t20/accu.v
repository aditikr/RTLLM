module accu(
    input  logic clk,
    input  logic rst_n,
    input  logic [7:0] data_in,
    input  logic valid_in,
    output logic valid_out,
    output logic [9:0] data_out
);
    reg [9:0] sum;
    reg [1:0] count;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum <= 0;
            count <= 0;
            valid_out <= 0;
        end else begin
            if (valid_in) begin
                if (count < 3) begin
                    sum <= sum + data_in;  // Accumulate input
                    count <= count + 1;
                    valid_out <= 0;        // Not yet four inputs, so valid_out is 0
                end else begin
                    sum <= sum + data_in;  // Accumulate the fourth input
                    data_out <= sum + data_in;  // Output the sum
                    valid_out <= 1;        // Signal that the output is valid
                    count <= 0;            // Reset the count
                    sum <= 0;              // Reset the sum
                end
            end else begin
                valid_out <= 0;            // If no valid input, valid_out should be 0
            end
        end
    end
endmodule
