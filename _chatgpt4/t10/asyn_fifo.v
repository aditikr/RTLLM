module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wrstn,
    input winc,
    input [WIDTH-1:0] wdata,
    input rclk,
    input rrstn,
    input rinc,
    output reg [WIDTH-1:0] rdata,
    output reg wfull,
    output reg rempty
);

localparam ADDR_WIDTH = $clog2(DEPTH);

// RAM instantiation
reg [WIDTH-1:0] ram [DEPTH-1:0];
reg [ADDR_WIDTH-1:0] waddr, raddr;
wire [ADDR_WIDTH-1:0] waddr_gray, raddr_gray;
wire [ADDR_WIDTH-1:0] wptr_gray_next, rptr_gray_next;
reg [ADDR_WIDTH-1:0] wptr_gray, rptr_gray;
reg [ADDR_WIDTH-1:0] wptr_gray_sync1, wptr_gray_sync2;
reg [ADDR_WIDTH-1:0] rptr_gray_sync1, rptr_gray_sync2;

// Write logic
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        waddr <= 0;
        wptr_gray <= 0;
    end else if (winc && !wfull) begin
        ram[waddr] <= wdata;
        waddr <= waddr + 1;
        wptr_gray <= wptr_gray_next;
    end
end

// Read logic
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        raddr <= 0;
        rptr_gray <= 0;
        rdata <= 0;
    end else if (rinc && !rempty) begin
        rdata <= ram[raddr];
        raddr <= raddr + 1;
        rptr_gray <= rptr_gray_next;
    end
end

// Gray code conversion
function [ADDR_WIDTH-1:0] bin_to_gray(input [ADDR_WIDTH-1:0] bin);
    bin_to_gray = bin ^ (bin >> 1);
endfunction

function [ADDR_WIDTH-1:0] gray_to_bin(input [ADDR_WIDTH-1:0] gray);
    integer i;
    begin
        gray_to_bin = gray;
        for (i = 1; i < ADDR_WIDTH; i = i << 1) begin
            gray_to_bin = gray_to_bin ^ (gray_to_bin >> i);
        end
    end
endfunction

// Next state Gray code pointers
assign wptr_gray_next = bin_to_gray(waddr + 1);
assign rptr_gray_next = bin_to_gray(raddr + 1);

// Synchronizing read pointer to write clock domain
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        rptr_gray_sync1 <= 0;
        rptr_gray_sync2 <= 0;
    end else begin
        rptr_gray_sync1 <= rptr_gray;
        rptr_gray_sync2 <= rptr_gray_sync1;
    end
end

// Synchronizing write pointer to read clock domain
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        wptr_gray_sync1 <= 0;
        wptr_gray_sync2 <= 0;
    end else begin
        wptr_gray_sync1 <= wptr_gray;
        wptr_gray_sync2 <= wptr_gray_sync1;
    end
end

// Full and empty logic
always @(*) begin
    wfull = (wptr_gray_next == {~rptr_gray_sync2[ADDR_WIDTH-1], rptr_gray_sync2[ADDR_WIDTH-2:0]});
    rempty = (rptr_gray == wptr_gray_sync2);
end

endmodule
