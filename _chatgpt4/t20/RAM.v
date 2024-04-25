module RAM (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        write_en,
    input  wire [2:0]  write_addr,
    input  wire [5:0]  write_data,
    input  wire        read_en,
    input  wire [2:0]  read_addr,
    output reg  [5:0]  read_data
);

    // Parameter definitions
    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // RAM array declaration
    reg [WIDTH-1:0] ram [DEPTH-1:0];

    // Write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize all RAM contents to zero on reset
            integer i;
            for (i = 0; i < DEPTH; i = i + 1) begin
                ram[i] <= 6'b000000;
            end
        end else if (write_en) begin
            // Write data to RAM at address specified by write_addr
            ram[write_addr] <= write_data;
        end
    end

    // Read operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset the read_data
            read_data <= 6'b000000;
        end else if (read_en) begin
            // Read data from RAM at address specified by read_addr
            read_data <= ram[read_addr];
        end else begin
            // Clear read_data when read is not enabled
            read_data <= 6'b000000;
        end
    end

endmodule
