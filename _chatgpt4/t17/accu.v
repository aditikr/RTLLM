module accu (
    input        clk,
    input        rst_n,
    input [7:0]  data_in,
    input        valid_in,
    output reg   valid_out,
    output reg [9:0] data_out
);

    // Internal registers for storing data and counting
    reg [9:0] accumulator;
    reg [2:0] count;  // 3-bit count to handle up to 4

    // Reset and accumulation logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 0;
            count       <= 0;
            data_out    <= 0;
            valid_out   <= 0;
        end else begin
            if (valid_in) begin
                if (count < 4) begin
                    // Accumulate input data
                    accumulator <= accumulator + data_in;
                    count       <= count + 1;
                end
                
                if (count == 3) begin
                    // On the fourth valid data, output the results
                    data_out <= accumulator + data_in;  // Add current data as well
                    valid_out <= 1;  // Set valid output high for one cycle
                    accumulator <= 0; // Reset accumulator for the next group
                    count <= 0;      // Reset count after the fourth data
                end else begin
                    valid_out <= 0; // Ensure valid_out is low unless 4th data just handled
                end
            end else if (count != 0 && count < 4) {
                // In case there's a pause in valid data, reset counters and output.
                accumulator <= 0;
                count       <= 0;
                data_out    <= 0;
                valid_out   <= 0;
            end
        end
    end
endmodule
