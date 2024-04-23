module RAM (
    input       clk,
    input       rst_n,
    input       write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input       read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data
);

// Parameter definitions
parameter WIDTH = 6;
parameter DEPTH = 8;

// RAM array declaration
reg [WIDTH-1:0] RAM [DEPTH-1:0];

// Write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition: Initialize the RAM to 0
        integer i;
        for (i = 0; i < DEPTH; i = i + 1) begin
            RAM[i] <= 0;
        end
    end
    else if (write_en) begin
        // Write data into RAM at the specified address if write enable is high
        RAM[write_addr] <= write_data;
    end
end

// Read operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition: Set the read data to 0 on reset
        read_data <= 0;
    end
    else if (read_en) begin
        // Return the data from RAM at the specified address if read enable is high
        read_data <= RAM[read_addr];
    end
    else begin
        // Ensure that read_data does not hold stale values when read_en is not active
        read_data <= 0;
    end
end

endmodule
