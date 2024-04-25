module RAM (
    input logic clk,
    input logic rst_n,
    input logic write_en,
    input logic [2:0] write_addr,  // Using 3 bits for address, since 2^3 = 8
    input logic [5:0] write_data,
    input logic read_en,
    input logic [2:0] read_addr,
    output logic [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // Declare RAM array
    logic [WIDTH-1:0] mem [DEPTH-1:0];

    // Write operation
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize RAM to zeros on reset
            for (int i = 0; i < DEPTH; i++) begin
                mem[i] <= 6'b000000;
            end
        end else if (write_en) begin
            // Perform write operation
            mem[write_addr] <= write_data;
        end
    end
    
    // Read operation
    always_ff @(posedge clk) begin
        if (read_en) begin
            // Perform read operation
            read_data <= mem[read_addr];
        end else begin
            read_data <= 6'b000000;  // Optionally clear read_data when not reading
        end
    end
    
endmodule
