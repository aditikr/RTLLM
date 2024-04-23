module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire wclk,
    input  wire rclk,
    input  wire wrstn,
    input  wire rrstn,
    input  wire winc,
    input  wire rinc,
    input  wire [WIDTH-1:0] wdata,
    output reg  [WIDTH-1:0] rdata,
    output wire wfull,
    output wire rempty
);

// Local parameters for address calculation
localparam ADDR_WIDTH = $clog2(DEPTH);

// RAM Storage
reg [WIDTH-1:0] ram[DEPTH-1:0];

// Write and Read Pointers
reg [ADDR_WIDTH-1:0] wptr = 0, rptr = 0;
reg [ADDR_WIDTH-1:0] wptr_gray = 0, rptr_gray = 0;
reg [ADDR_WIDTH-1:0] rptr_gray_sync1 = 0, rptr_gray_sync2 = 0;

// Write operations
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wptr <= 0;
        wptr_gray <= 0;
    end else if (winc && !wfull) begin
        ram[wptr] <= wdata;
        wptr <= wptr + 1;
        wptr_gray <= (wptr + 1) ^ (wptr + 1) >> 1;
    end
end

// Read operations
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rptr <= 0;
        rptr_gray <= 0;
        rptr_gray_sync1 <= 0;
        rptr_gray_sync2 <= 0;
    end else begin
        rptr_gray_sync1 <= wptr_gray;
        rptr_gray_sync2 <= rptr_gray_sync1;  // Synchronization to read clock domain
        if (rinc && !rempty) begin
            rdata <= ram[rptr];
            rptr <= rptr + 1;
            rptr_gray <= (rptr + 1) ^ (rptr + 1) >> 1;
        end
    end
end

// Full and empty logic
wire wptr_match_rptr = (wptr_gray == rptr_gray);

assign rempty = wptr_match_rptr;

// Generate full signal using gray code
wire rptr_gray_inv = ~rptr_gray[ADDR_WIDTH-1] 
                    & ~rptr_gray[ADDR_WIDTH-2] 
                    & rptr_gray[ADDR_WIDTH-3:0];

assign wfull = wptr_gray == rptr_gray_inv;

endmodule
