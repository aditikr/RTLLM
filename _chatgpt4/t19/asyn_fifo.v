module asyn_fifo #(
    parameter WIDTH = 8,  // Data width
    parameter DEPTH = 16  // FIFO depth
)(
    input  wire                  wclk,   // Write clock
    input  wire                  rclk,   // Read clock
    input  wire                  wrstn,  // Write reset (active low)
    input  wire                  rrstn,  // Read reset (active low)
    input  wire                  winc,   // Write increment
    input  wire                  rinc,   // Read increment
    input  wire [WIDTH-1:0]      wdata,  // Write data
    output wire                  wfull,  // Write full signal
    output wire                  rempty, // Read empty signal
    output reg  [WIDTH-1:0]      rdata   // Read data
);

    localparam ADDR_WIDTH = $clog2(DEPTH);  // Address width

    reg [ADDR_WIDTH:0] wptr_gray = 0, rptr_gray = 0;
    reg [ADDR_WIDTH:0] wptr_bin = 0, rptr_bin = 0;
    reg [ADDR_WIDTH:0] rptr_syn;
    reg [ADDR_WIDTH:0] wptr_syn;

    wire [ADDR_WIDTH:0] wptr_gray_next, rptr_gray_next;
    wire [ADDR_WIDTH:0] wptr_bin_next, rptr_bin_next;
    wire wen, ren;
    wire [ADDR_WIDTH-1:0] waddr, raddr;

    // Dual-port RAM instantiation
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    // Binary to Gray conversion
    assign wptr_gray_next = (wptr_bin_next >> 1) ^ wptr_bin_next;
    assign rptr_gray_next = (rptr_bin_next >> 1) ^ rptr_bin_next;

    // Gray to Binary conversion for read pointer synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= wptr_gray_next;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= rptr_gray_next;
        end
    end

    assign wptr_bin_next = wptr_bin + 1;
    assign rptr_bin_next = rptr_bin + 1;

    // Synch gray pointers across clock domains
    always @(posedge rclk) begin
        wptr_syn <= wptr_gray;
    end

    always @(posedge wclk) begin
        rptr_syn <= rptr_gray;
    end

    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];
    assign wen = winc && !wfull;
    assign ren = rinc && !rempty;

    // RAM read/write operations
    always @(posedge wclk) begin
        if (wen) RAM[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (ren) rdata <= RAM[raddr];
    end

    // Full and empty logic
    assign wfull = (wptr_gray_next == {~rptr_syn[ADDR_WIDTH:ADDR_WIDTH-1], rptr_syn[ADDR_WIDTH-2:0]});
    assign rempty = (rptr_gray == wptr_syn);

endmodule
