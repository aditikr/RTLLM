module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,  // 3-bit address for 8 depth locations
    input [5:0] write_data,  // 6-bit data width
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data
);
    // Parameters for width and depth
    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // RAM array
    reg [WIDTH-1:0] ram [DEPTH-1:0];

    // Initialization and reset handling
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset: Initialize RAM to zero
            for (i = 0; i < DEPTH; i = i + 1) begin
                ram[i] <= 0;
            end
            read_data <= 0;
        end
        else if (write_en) begin
            // Write operation
            ram[write_addr] <= write_data;
        end
    end

    // Read operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset read data
            read_data <= 0;
        end
        else if (read_en) begin
            // Read operation
            read_data <= ram[read_addr];
        end
        else begin
            // Clear read_data if read_en is not active
            read_data <= 0;
        end
    end
endmodule
