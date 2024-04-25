module serial2parallel(
    input  logic clk,
    input  logic rst_n,
    input  logic din_serial,
    input  logic din_valid,
    output logic [7:0] dout_parallel,
    output logic dout_valid
);

    // Internal variables
    logic [7:0] shift_reg;  // Shift register to store serial bits
    logic [2:0] cnt;        // 3-bit counter to count the valid bits

    // Handle positive edges of clk and asynchronous reset
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset conditions
            shift_reg <= 8'b0;
            cnt <= 3'b0;
            dout_valid <= 0;
        end else begin
            if (din_valid) begin
                // Shift left and insert new bit at LSB
                shift_reg <= (shift_reg << 1) | din_serial;
                if (cnt == 3'b111) begin
                    // Check if 8 bits have been received
                    dout_parallel <= shift_reg;
                    dout_valid <= 1'b1;
                    cnt <= 3'b0;
                end else begin
                    cnt <= cnt + 1;
                    dout_valid <= 1'b0;
                end
            end else begin
                dout_valid <= 1'b0;
            end
        end
    end
endmodule
