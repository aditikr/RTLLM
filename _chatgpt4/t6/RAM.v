
module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,  // 3-bit address for 8 depth
    input [5:0] write_data,  // 6-bit data width
    input read_en,
    input [2:0] read_addr,   // 3-bit address for 8 depth
    output reg [5:0] read_data  // 6-bit data width
);

parameter WIDTH = 6;
parameter DEPTH = 8;

// Memory array
reg [WIDTH-1:0] ram [DEPTH-1:0];

// Write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset: Initialize RAM to 0
        integer i;
        for (i = 0; i < DEPTH; i = i + 1) begin
            ram[i] <= 6'b000000;
        end
    end else if (write_en) begin
        // Write data to RAM
        ram[write_addr] <= write_data;
    end
end

// Read operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset: Clear read_data
        read_data <= 6'b000000;
    end else if (read_en) begin
        // Read data from RAM
        read_data <= ram[read_addr];
    end else begin
        // Clear read_data if read is not enabled
        read_data <= 6'b000000;
    end
end

endmodule
