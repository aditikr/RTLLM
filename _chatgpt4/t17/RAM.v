module RAM (
    input logic clk,
    input logic rst_n,
    input logic write_en,
    input logic [2:0] write_addr, // Address range 0 to 7 for 8-depth RAM
    input logic [5:0] write_data, // 6-bit width data
    input logic read_en,
    input logic [2:0] read_addr,  // Address range 0 to 7 for 8-depth RAM
    output logic [5:0] read_data  // 6-bit width data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // RAM array
    logic [WIDTH-1:0] ram [DEPTH-1:0];

    // Write operation
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize RAM on reset
            ram[0] <= 6'b000000;
            ram[1] <= 6'b000000;
            ram[2] <= 6'b000000;
            ram[3] <= 6'b000000;
            ram[4] <= 6'b000000;
            ram[5] <= 6'b000000;
            ram[6] <= 6'b000000;
            ram[7] <= 6'b000000;
        end else if (write_en) begin
            // Write data to RAM
            ram[write_addr] <= write_data;
        end
    end

    // Read operation
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= 6'b000000; // Clear read_data on reset
        end else if (read_en) begin
            read_data <= ram[read_addr]; // Assign data from RAM to output
        end else begin
            read_data <= 6'b000000; // Clear output when not reading
        end
    end

endmodule
