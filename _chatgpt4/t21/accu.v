module accu(
    input        clk,        // Clock input
    input        rst_n,      // Active-low reset signal
    input [7:0]  data_in,    // 8-bit input data
    input        valid_in,   // Signal indicating valid data input
    output logic valid_out,  // Signal indicating output validity
    output logic [9:0] data_out  // 10-bit output for the accumulated sum
);

    // Internal registers
    reg [9:0] sum;             // Register to store the running sum
    reg [2:0] count;           // Count register to keep track of number of data received

    // Process logic for accumulating inputs and generating outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum <= 10'd0;
            count <= 3'd0;
            valid_out <= 1'b0;
        end else begin
            if (valid_in) begin
                if (count == 3'd3) begin
                    // Complete a batch of 4 data, output the result
                    sum <= data_in;
                    count <= 3'd1;  // reset count after fourth input
                    data_out <= sum + data_in;
                    valid_out <= 1'b1;  // Set valid_out high for one cycle
                end else begin
                    // Accumulate sum and increment count
                    sum <= sum + data_in;
                    count <= count + 1;
                    valid_out <= 1'b0;
                end
            end else begin
                valid_out <= 1'b0;  // Maintain valid_out low if not receiving valid input
            end
        end
    end

    // Handle the blocking output assignment
    always @(posedge clk) begin
        if (valid_out) begin
            valid_out <= 1'b0;  // Reset valid_out after one cycle
        end
    end

endmodule
