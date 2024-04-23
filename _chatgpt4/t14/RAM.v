module RAM (
    input wire clk,              // Clock signal
    input wire rst_n,            // Active-low reset signal
    input wire write_en,         // Write enable signal
    input wire [2:0] write_addr, // Write address (3 bits for addressing 8 locations)
    input wire [5:0] write_data, // 6-bit data to write
    input wire read_en,          // Read enable signal
    input wire [2:0] read_addr,  // Read address
    output reg [5:0] read_data   // Data read from RAM
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // Memory array declaration
    reg [WIDTH-1:0] ram [DEPTH-1:0];

    // Write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all memory locations during reset
            integer i;
            for (i = 0; i < DEPTH; i = i + 1) begin
                ram[i] <= 6'b000000;
            end
        end else if (write_en) begin
            // Perform memory write operation
            ram[write_addr] <= write_data;
        end
    end

    // Read operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear the read_data output on reset
            read_data <= 6'b000000;
        end else if (read_en) begin
            // Perform memory read operation
            read_data <= ram[read_addr];
        end else begin
            read_data <= 6'b000000; // Optionally clear the read_data if read_en is not active
        end
    end

endmodule
