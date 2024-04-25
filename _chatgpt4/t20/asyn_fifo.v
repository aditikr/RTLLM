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

// Memory and Pointer Declaration
reg [WIDTH-1:0] mem [0:DEPTH-1];
reg [ADDR_WIDTH-1:0] waddr, raddr;
reg [ADDR_WIDTH:0] wptr_gray, rptr_gray, wptr_gray_r, rptr_gray_w;

// Synchronization Logic
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        waddr <= 0;
        wptr_gray <= 0;
    end else if (winc && !wfull) begin
        mem[waddr] <= wdata;
        waddr <= waddr + 1;
        wptr_gray <= (waddr + 1) ^ ((waddr + 1) >> 1);
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        raddr <= 0;
        rptr_gray <= 0;
    end else if (rinc && !rempty) begin
        rdata <= mem[raddr];
        raddr <= raddr + 1;
        rptr_gray <= (raddr + 1) ^ ((raddr + 1) >> 1);
    end
end

// Synchronization of Gray pointers
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        wptr_gray_r <= 0;
    end else begin
        wptr_gray_r <= wptr_gray;
    end
end

always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        rptr_gray_w <= 0;
    end else begin
        rptr_gray_w <= rptr_gray;
    end
end

// Checking full and empty conditions
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wfull <= 0;
    end else begin
        wfull <= (wptr_gray[ADDR_WIDTH:ADDR_WIDTH-1] == ~rptr_gray_w[ADDR_WIDTH:ADDR_WIDTH-1]) &&
                  (wptr_gray[ADDR_WIDTH-2:0] == rptr_gray_w[ADDR_WIDTH-2:0]);
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rempty <= 1;
    end else begin
        rempty <= rptr_gray == wptr_gray_r;
    end
end

endmodule
