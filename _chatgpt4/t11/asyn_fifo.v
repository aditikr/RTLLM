module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

localparam ADDR_WIDTH = $clog2(DEPTH);

// RAM instantiation
reg [WIDTH-1:0] ram [DEPTH-1:0];
reg [ADDR_WIDTH-1:0] waddr, raddr;
reg wenc, renc;

always @(posedge wclk) begin
    if (wenc) begin
        ram[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (renc) begin
        rdata <= ram[raddr];
    end
end

// Pointer logic
reg [ADDR_WIDTH:0] wptr, rptr;
reg [ADDR_WIDTH:0] wptr_gray, rptr_gray;
reg [ADDR_WIDTH:0] rptr_gray_sync1, rptr_gray_sync2;
reg [ADDR_WIDTH:0] wptr_gray_sync1, wptr_gray_sync2;

// Binary to Gray conversion
function [ADDR_WIDTH:0] bin_to_gray(input [ADDR_WIDTH:0] bin);
    bin_to_gray = bin ^ (bin >> 1);
endfunction

// Gray to Binary conversion
function [ADDR_WIDTH:0] gray_to_bin(input [ADDR_WIDTH:0] gray);
    integer i;
    begin
        gray_to_bin = gray;
        for (i = 1; i <= ADDR_WIDTH; i = i << 1) begin
            gray_to_bin = gray_to_bin ^ (gray_to_bin >> i);
        end
    end
endfunction

// Write pointer management
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wptr <= 0;
        wptr_gray <= 0;
    end else if (winc && !wfull) begin
        wptr <= wptr + 1;
        wptr_gray <= bin_to_gray(wptr + 1);
    end
end

// Read pointer management
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rptr <= 0;
        rptr_gray <= 0;
    end else if (rinc && !rempty) begin
        rptr <= rptr + 1;
        rptr_gray <= bin_to_gray(rptr + 1);
    end
end

// Synchronizing read pointer to write clock domain
always @(posedge wclk) begin
    rptr_gray_sync1 <= rptr_gray;
    rptr_gray_sync2 <= rptr_gray_sync1;
end

// Synchronizing write pointer to read clock domain
always @(posedge rclk) begin
    wptr_gray_sync1 <= wptr_gray;
    wptr_gray_sync2 <= wptr_gray_sync1;
end

// Full and empty logic
always @(*) begin
    wfull = (wptr_gray == {~rptr_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1], rptr_gray_sync2[ADDR_WIDTH-2:0]});
    rempty = (rptr_gray == wptr_gray_sync2);
end

// RAM read/write enable
always @(*) begin
    wenc = winc && !wfull;
    renc = rinc && !rempty;
    waddr = gray_to_bin(wptr_gray)[ADDR_WIDTH-1:0];
    raddr = gray_to_bin(rptr_gray)[ADDR_WIDTH-1:0];
end

endmodule
