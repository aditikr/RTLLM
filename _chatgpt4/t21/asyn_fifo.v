module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire         wclk,
    input  wire         rclk,
    input  wire         wrstn,
    input  wire         rrstn,
    input  wire         winc,
    input  wire         rinc,
    input  wire [WIDTH-1:0] wdata,
    output reg          wfull,
    output reg          rempty,
    output reg [WIDTH-1:0] rdata
);

    // Local parameters for address width based on DEPTH
    localparam ADDR_WIDTH = $clog2(DEPTH);
    
    // RAM Declaration
    reg [WIDTH-1:0] ram[DEPTH-1:0];
    
    // Write and Read pointers in binary and Gray code
    reg [ADDR_WIDTH-1:0] wptr_bin = 0, rptr_bin = 0;
    reg [ADDR_WIDTH-1:0] wptr_gray = 0, rptr_gray = 0;
    reg [ADDR_WIDTH-1:0] wptr_gray_sync1 = 0, wptr_gray_sync2 = 0;
    reg [ADDR_WIDTH-1:0] rptr_gray_sync1 = 0, rptr_gray_sync2 = 0;

    // Write logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            ram[wptr_bin] = wdata; 
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);
        end
    end

    // Write pointer Gray code synchronizer in Read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1 <= 0;
            wptr_gray_sync2 <= 0;
        end else begin
            wptr_gray_sync1 <= wptr_gray;
            wptr_gray_sync2 <= wptr_gray_sync1;
        end
    end

    // Read logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            rdata <= 0;
        end else if (rinc && !rempty) begin
            rdata <= ram[rptr_bin];
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1);
        end
    end

    // Read pointer Gray code synchronizer in Write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1 <= 0;
            rptr_gray_sync2 <= 0;
        end else begin
            rptr_gray_sync1 <= rptr_gray;
            rptr_gray_sync2 <= rptr_gray_sync1;
        end
    end

    // Full and Empty logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 0;
        end else begin
            wfull <= (wptr_gray[ADDR_WIDTH-1 : 0] == (~rptr_gray_sync2[ADDR_WIDTH-1] & rptr_gray_sync2[ADDR_WIDTH-2:0]));
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1;
        end else begin
            rempty <= (rptr_gray == wptr_gray_sync2);
        end
    end

endmodule
