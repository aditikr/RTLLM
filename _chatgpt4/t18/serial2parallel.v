module serial2parallel (
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output [7:0] dout_parallel,
    output       dout_valid
);

    // Internal signals
    reg [7:0] shift_reg;       // Shift register to store the serial bits temporarily
    reg [2:0] cnt;             // 3-bit counter since it counts from 0 to 7 (8 cycles total)
    reg       reg_dout_valid;  // Latched output valid signal

    // Output assignments
    assign dout_parallel = shift_reg;
    assign dout_valid = reg_dout_valid;

    // Process block: capture serial data and convert to parallel output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset logic
            shift_reg <= 8'b0;
            cnt <= 3'b0;
            reg_dout_valid <= 1'b0;
        end else begin
            if (din_valid) begin
                // Shift in the serial data from MSB to LSB
                shift_reg <= {din_serial, shift_reg[7:1]};

                // Count the number of valid serial bits received
                if (cnt == 3'b111) begin
                    cnt <= 3'b0;  // Reset counter if 8 bits have been received
                    reg_dout_valid <= 1'b1;  // Set output valid high only when 8 bits are shifted in
                end else begin
                    cnt <= cnt + 1;
                    reg_dout_valid <= 1'b0;  // Keep output valid low while receiving bits
                end
            end else begin
                // When no valid data is being received
                reg_dout_valid <= 1'b0;
            end
        end
    end
endmodule
