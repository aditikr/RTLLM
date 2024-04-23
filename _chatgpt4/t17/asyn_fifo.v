module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wclk,
    input  wrstn,
    input  winc,
    input  [WIDTH-1:0] wdata,
    input  rclk,
    input  rrstn,
    input  rinc,
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

// Local parameter for address width calculation
localparam ADDR_WIDTH = $clog2(DEPTH);

// RAM instantiation
reg [WIDTH-1:0] ram[DEPTH-1:0];
reg [ADDR_WIDTH-1:0] waddr, raddr;

// Gray code pointers
reg [ADDR_WIDTH:0] wptr_gray, rptr_gray;

// Binary pointers
reg [ADDR_WIDTH:0] wptr_bin, rptr_bin;

// Synchronized pointers
reg [ADDR_WIDTH:0] wptr_gray_sync, rptr_gray_sync;
reg [ADDR_WIDTH:0] wptr_bin_sync, rptr_bin_sync;

// Pointer increments
wire [ADDR_WIDTH:0] wptr_bin_next = wptr_bin + (winc & ~wfull);
wire [ADDR_WIDTH:0] rptr_bin_next = rptr_bin + (rinc & ~rempty);

// Convert binary to Gray code
function [ADDR_WIDTH:0] bin_to_gray(input [ADDR_WIDTH:0] bin);
    bin_to_gray = (bin >> 1) ^ bin;
endfunction

// Convert Gray code to binary
function [ADDR_WIDTH:0] gray_to_bin(input [ADDR_WIDTH:0] gray);
    reg [ADDR_WIDTH:0] bin;
    integer i;
    begin
        bin = gray;
        for (i = 1; i < ADDR_WIDTH; i = i << 1)
            bin = bin ^ (bin >> i);
        gray_to_bin = bin;
    end
endfunction

// Write pointer logic
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wptr_bin <= 0;
        wptr_gray <= 0;
    end else begin
        wptr_bin <= wptr_bin_next;
        wptr_gray <= bin_to_gray(wptr_bin_next);
    end
end

// Read pointer logic
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rptr_bin <= 0;
        rptr_gray <= 0;
    end else begin
        rptr_bin <= rptr_bin_next;
        rptr_gray <= bin_to_gray(rptr_bin_next);
    end
end

// Pointer synchronization from read to write domain
always @(posedge wclk) begin
    rptr_gray_sync <= rptr_gray;
    rptr_bin_sync <= gray_to_bin(rptr_gray_sync);
end

// Pointer synchronization from write to read domain
always @(posedge rclk) begin
    wptr_gray_sync <= wptr_gray;
    wptr_bin_sync <= gray_to_bin(wptr_gray_sync);
end

// Full and empty logic
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn)
        wfull <= 0;
    else
        wfull <= (wptr_bin_next == {~rptr_bin_sync[ADDR_WIDTH:ADDR_WIDTH-1], rptr_bin_sync[ADDR_WIDTH-2:0]});
end

always @(posedge rclk or negedge rrstn) begin
    if (!rrstn)
        rempty <= 1;
    else
        rempty <= (rptr_bin_next == wptr_bin_sync);
end

// RAM read and write operations
always @(posedge wclk) begin
    if (winc && !wfull)
        ram[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
end

always @(posedge rclk) begin
    if (rinc && !rempty)
        rdata <= ram[rptr_bin[ADDR_WIDTH-1:0]];
end

endmodule
