module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Internal variables
    reg [9:0] accumulator = 0;
    reg [2:0] count = 0;  // Only need to count up to 4

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset logic
            accumulator <= 0;
            count <= 0;
            valid_out <= 0;
            data_out <= 0;
        end else begin
            if (valid_in) begin
                // Process input
                accumulator <= accumulator + data_in;
                count <= count + 1;
                
                if (count == 3) begin  // Check for 4th input (count starts from 0)
                    // Output logic
                    data_out <= accumulator;
                    valid_out <= 1;
                    accumulator <= 0;  // Reset accumulator
                    count <= 0;        // Reset count
                end else begin
                    valid_out <= 0;
                end
            end else begin
                valid_out <= 0;
            end
        end
    end

endmodule
