module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,     // 3-bit address for 8 depth
    input [5:0] write_data,     // 6-bit data width
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data  // 6-bit data width
);

// Parameters for width and depth
parameter WIDTH = 6;
parameter DEPTH = 8;

// RAM Array - 8 entries of 6 bit width
reg [WIDTH-1:0] ram [DEPTH-1:0];

// Initial block for setting default values
integer i;
initial begin
    for (i = 0; i < DEPTH; i = i + 1) begin
        ram[i] = 6'b000000;  // Initialize all data to '000000'
    end
end

// Write operation on positive clock edge or negative reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // If reset, clear all RAM to '000000'
        for (i = 0; i < DEPTH; i = i + 1) begin
            ram[i] <= 6'b000000;
        end
    end else if (write_en) begin
        // Write data to RAM at address write_addr
        ram[write_addr] <= write_data;
    end
end

// Read operation on positive clock edge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // If reset, set read_data to '000000'
        read_data <= 6'b000000;
    end else if (read_en) begin
        // If read enabled, read data from RAM at address read_addr
        read_data <= ram[read_addr];
    end else begin
        // If not reading, clear read_data
        read_data <= 6'b000000;
    end
end

endmodule
