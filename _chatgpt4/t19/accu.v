module accu (
    input        clk,
    input        rst_n,
    input [7:0]  data_in,
    input        valid_in,
    output logic valid_out,
    output logic [9:0] data_out
);

    // Internal variables
    reg [9:0]  data_sum;
    reg [1:0]  count;  // To count up to 4 inputs

    // Manage data accumulation and output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_sum <= 10'd0;
            count <= 2'b00;
            valid_out <= 1'b0;
        end else begin
            if (valid_in) begin
                // When receiving valid data
                if (count < 2'b11) begin
                    data_sum <= data_sum + data_in;  // Sum the data
                    count <= count + 1'b1;
                    valid_out <= 1'b0;
                end else begin
                    // On the fourth valid data
                    data_sum <= data_sum + data_in;
                    data_out <= data_sum + data_in;  // Output the accumulated result
                    valid_out <= 1'b1;  // Set valid_out high for a cycle
                    count <= 2'b00;     // Reset the count
                    data_sum <= 10'd0;  // Reset the sum
                end
            end else if (valid_out) begin
                // Clear valid_out after output has been set
                valid_out <= 1'b0;
            end
        end
    end

endmodule
