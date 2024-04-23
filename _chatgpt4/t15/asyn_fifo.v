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

localparam PTR_WIDTH = $clog2(DEPTH);
localparam GRAY_WIDTH = PTR_WIDTH + 1;

// RAM instantiation
reg [WIDTH-1:0] ram [DEPTH-1:0];
reg [PTR_WIDTH-1:0] waddr, raddr;
reg wren, rren;

always @(posedge wclk) begin
    if (wren) begin
        ram[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (rren) begin
        rdata <= ram[raddr];
    end
end

// Write and read pointers management
reg [GRAY_WIDTH-1:0] wptr_gray, rptr_gray;
reg [GRAY_WIDTH-1:0] wptr_gray_next, rptr_gray_next;
reg [PTR_WIDTH-1:0] wptr_bin, rptr_bin;

// Binary to Gray conversion
function [GRAY_WIDTH-1:0] bin_to_gray(input [GRAY_WIDTH-1:0] bin);
    bin_to_gray = bin ^ (bin >> 1);
endfunction

// Gray to Binary conversion
function [GRAY_WIDTH-1:0] gray_to_bin(input [GRAY_WIDTH-1:0] gray);
    reg [GRAY_WIDTH-1:0] bin;
    begin
        bin = gray ^ (gray >> 8);
        bin ^= (bin >> 4);
        bin ^= (bin >> 2);
        bin ^= (bin >> 1);
        gray_to_bin = bin;
    end
endfunction

// Pointer increment and gray conversion
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wptr_bin <= 0;
        wptr_gray <= 0;
    end else begin
        if (winc && !wfull) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= bin_to_gray(wptr_bin + 1);
        end
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rptr_bin <= 0;
        rptr_gray <= 0;
    end else begin
        if (rinc && !rempty) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= bin_to_gray(rptr_bin + 1);
        end
    end
end

// Synchronizers and FIFO logic
reg [GRAY_WIDTH-1:0] rptr_gray_sync1, rptr_gray_sync2;
always @(posedge wclk) begin
    rptr_gray_sync1 <= rptr_gray;
    rptr_gray_sync2 <= rptr_gray_sync1;
end

reg [GRAY_WIDTH-1:0] wptr_gray_sync1, wptr_gray_sync2;
always @(posedge rclk) begin
    wptr_gray_sync1 <= wptr_gray;
    wptr_gray_sync2 <= wptr_gray_sync1;
end

always @(wptr_gray, rptr_gray_sync2, GRAY_WIDTH) begin
    // Full when the next gray write pointer matches the bitwise negation of the gray read pointer
    wfull = (wptr_gray_next == (~rptr_gray_sync2));
end

always @(rptr_gray, wptr_gray_sync2, GRAY_WIDTH) begin
    // Empty when the synced write pointer equals the read pointer
    rempty = (rptr_gray == wptr_gray_sync2);
end

// Connection to RAM ports
always @* begin
    wren = winc && !wfull;
    rren = rinc && !rempty;
    waddr = wptr_bin[PTR_WIDTH-1:0];
    raddr = rptr_bin[PTR_WIDTH-1:0];
end

endmodule
