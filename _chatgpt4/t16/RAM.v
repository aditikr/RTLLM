module RAM (
    input logic clk,
    input logic rst_n,
    input logic write_en,
    input logic [2:0] write_addr,  // Address range for DEPTH=8 is 3 bits (0 to 7)
    input logic [5:0] write_data,  // Data width is 6 bits
    input logic read_en,
    input logic [2:0] read_addr,   // Address range for DEPTH=8 is 3 bits (0 to 7)
    output logic [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // Memory array declaration
    logic [WIDTH-1:0] ram [DEPTH-1:0];

    // Write operation
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset memory content to 0
            integer i;
            for (i = 0; i < DEPTH; i++) begin
                ram[i] <= 6'b0;
            end
        end else if (write_en) begin
            // Write data to memory
            ram[write_addr] <= write_data;
        end
    end

    // Read operation
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= 6'b0;
        end else if (read_en) begin
            // Read data from memory
            read_data <= ram[read_addr];
        end else begin
            // Clear read_data if read_en is not active
            read_data <= 6'b0;
        end
    end

endmodule
