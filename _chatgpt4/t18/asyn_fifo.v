module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wire wclk,
    input wire rclk,
    input wire wrstn,
    input wire rrstn,
    input wire winc,
    input wire rinc,
    input wire [WIDTH-1:0] wdata,
    output wire wfull,
    output wire rempty,
    output reg [WIDTH-1:0] rdata
);

    // Parameters for addressing and pointer size
    localparam PTR_WIDTH = $clog2(DEPTH);

    // RAM instantiation
    reg [WIDTH-1:0] ram[DEPTH-1:0];
    reg [PTR_WIDTH-1:0] waddr, raddr;

    // Pointer registers
    reg [PTR_WIDTH:0] wptr_gray = 0, wptr_bin = 0;
    reg [PTR_WIDTH:0] rptr_gray = 0, rptr_bin = 0;
    reg [PTR_WIDTH:0] wptr_gray_sync = 0;
    reg [PTR_WIDTH:0] rptr_gray_sync = 0;

    // Write operations
    always @(posedge wclk) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            ram[waddr] <= wdata;
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);
        end
    end

    always @(posedge rclk) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rdata <= ram[raddr];
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1);
        end
    end

    // Pointer Synchronization
    always @(posedge wclk) begin
        rptr_gray_sync <= rptr_gray;
    end

    always @(posedge rclk) begin
        wptr_gray_sync <= wptr_gray;
    end

    // Address calculation
    always @* begin
        waddr = wptr_bin[PTR_WIDTH-1:0];
        raddr = rptr_bin[PTR_WIDTH-1:0];
    end

    // Full and empty logic
    wire wfull_next = (wptr_gray[PTR_WIDTH] != rptr_gray_sync[PTR_WIDTH] &&
                       wptr_gray[PTR_WIDTH-1] != rptr_gray_sync[PTR_WIDTH-1] &&
                       wptr_gray[PTR_WIDTH-2:0] == rptr_gray_sync[PTR_WIDTH-2:0]);
    
    wire rempty_next = (wptr_gray_sync == rptr_gray);

    // Output assignments
    assign wfull = wfull_next;
    assign rempty = rempty_next;

endmodule
