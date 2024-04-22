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

// RAM
reg [WIDTH-1:0] ram [DEPTH-1:0];
reg [ADDR_WIDTH-1:0] waddr, raddr;
reg wren, rren;

// Write and read pointers
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
    reg [ADDR_WIDTH:0] bin;
    begin
        bin = gray;
        for (int i = 1; i <= ADDR_WIDTH; i = i << 1)
            bin = bin ^ (bin >> i);
        gray_to_bin = bin;
    end
endfunction

// Write logic
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wptr <= 0;
        wptr_gray <= 0;
        waddr <= 0;
        wren <= 0;
    end else begin
        wren <= winc && !wfull;
        if (wren) begin
            ram[waddr] <= wdata;
            wptr <= wptr + 1;
            wptr_gray <= bin_to_gray(wptr + 1);
            waddr <= wptr[ADDR_WIDTH-1:0];
        end
    end
end

// Read logic
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rptr <= 0;
        rptr_gray <= 0;
        raddr <= 0;
        rren <= 0;
        rdata <= 0;
    end else begin
        rren <= rinc && !rempty;
        if (rren) begin
            rdata <= ram[raddr];
            rptr <= rptr + 1;
            rptr_gray <= bin_to_gray(rptr + 1);
            raddr <= rptr[ADDR_WIDTH-1:0];
        end
    end
end

// Read pointer synchronization
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        rptr_gray_sync1 <= 0;
        rptr_gray_sync2 <= 0;
    end else begin
        rptr_gray_sync1 <= rptr_gray;
        rptr_gray_sync2 <= rptr_gray_sync1;
    end
end

// Write pointer synchronization
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
    wfull = (wptr_gray == {~rptr_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1], rptr_gray_sync2[ADDR_WIDTH-2:0]});
    rempty = (rptr_gray == wptr_gray_sync2);
end

endmodule
