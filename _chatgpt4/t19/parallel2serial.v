module parallel2serial(
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output       valid_out,
    output logic dout
);

    // Internal register to store parallel input
    reg [3:0] data = 4'b0000;
    // Counter to keep track of current bit output
    reg [1:0] cnt = 2'b00;
    // Output valid signal
    reg valid = 1'b0;

    // On each positive edge of the clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // If reset is low, reset the counter and clear valid
            cnt <= 2'b00;
            valid <= 1'b0;
            data <= 4'b0000;
        end else begin
            if (cnt == 2'b11) begin
                // Last bit has been shifted out
                data <= d;       // Load new data
                cnt <= 2'b00;    // Reset counter
                valid <= 1'b1;   // Set valid high to indicate new data is ready
            end else begin
                // Shift data to the left, bringing new bit into dout
                data <= data << 1;
                cnt <= cnt + 1'b1;  // Increment counter
                valid <= 1'b0;      // Clear valid since mid-operation
            end
        end
    end

    // Assign output data to the MSB of the shift register
    assign dout = data[3];
    // assign valid flag to the output valid signal
    assign valid_out = valid;

endmodule
