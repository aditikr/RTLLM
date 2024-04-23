module accu(
    input        clk,
    input        rst_n,
    input  [7:0] data_in,
    input        valid_in,
    output logic valid_out,
    output logic [9:0] data_out
);

    // This variable holds the accumulation of the inputs
    logic [9:0] sum;
    // Counter for the number of valid data received
    logic [2:0] count;

    // Handle data accumulation and counting
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum <= 10'b0;
            count <= 3'b0;
            valid_out <= 1'b0;
        end else if (valid_in) begin
            if (count == 3'b11) begin
                // On receiving the fourth piece of data
                sum <= sum + data_in;   // Add current data to sum
                data_out <= sum + data_in;  // Output sum including current data
                valid_out <= 1'b1;     // Set valid_out high for one cycle
                count <= 3'b0;         // Reset count
                sum <= 10'b0;          // Reset sum for next cycle
            end else begin
                sum <= sum + data_in;  // Accumulate given data
                count <= count + 3'b1;  // Increment count
                valid_out <= 1'b0;     // Keep valid_out low
            end
        end else begin
            valid_out <= 1'b0;         // Keep valid_out low if not valid input
        end
    end

    // Ensure data_out holds value for only one cycle when valid_out is set
    always @(posedge clk) begin
        if (valid_out) begin
            // No additional action needed currently
        end else begin
            data_out <= 10'b0; // reset data_out to 0 when not outputting to avoid holding state.
        end
    end
endmodule
