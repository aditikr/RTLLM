module RAM (
    input logic clk,
    input logic rst_n,
    input logic write_en,
    input logic [2:0] write_addr,  // Adjusted for 8 depth
    input logic [5:0] write_data,  // 6 bits wide data
    input logic read_en,
    input logic [2:0] read_addr,   // Adjusted for 8 depth
    output logic [5:0] read_data   // 6 bits wide output data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // Defining RAM array
    logic [WIDTH-1:0] ram [0:DEPTH-1];

    // Handle write operations
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Resetting/clearing the RAM
            int i;
            for (i = 0; i < DEPTH; i++) begin
                ram[i] <= 6'b000000;
            end
        end else if (write_en) begin
            // Writing data to RAM
            ram[write_addr] <= write_data;
        end
    end

    // Handle read operations
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= 6'b000000; // Reset read_data on reset
        end else if (read_en) begin
            read_data <= ram[read_addr]; // Reading data from RAM
        end else begin
            read_data <= 6'b000000; // Clear output if not reading
        end
    end

endmodule
