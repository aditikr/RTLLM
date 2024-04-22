
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end
endmodule

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
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);
    // Pointer width for Gray code
    localparam PTR_WIDTH = $clog2(DEPTH);

    // Pointers
    reg [PTR_WIDTH-1:0] wptr_bin = 0, rptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0, rptr_gray = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_sync1, wptr_gray_sync2;
    reg [PTR_WIDTH-1:0] rptr_gray_sync1, rptr_gray_sync2;

    // Dual-port RAM instantiation
    dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram (
        .wclk(wclk),
        .wenc(winc && !wfull),
        .waddr(wptr_bin[$clog2(DEPTH)-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc && !rempty),
        .raddr(rptr_bin[$clog2(DEPTH)-1:0]),
        .rdata(rdata)
    );

    // Binary to Gray conversion
    function [PTR_WIDTH-1:0] bin_to_gray(input [PTR_WIDTH-1:0] bin);
        bin_to_gray = bin ^ (bin >> 1);
    endfunction

    // Gray to Binary conversion
    function [PTR_WIDTH-1:0] gray_to_bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray_to_bin = gray;
            for (i = 1; i < PTR_WIDTH; i = i << 1) begin
                gray_to_bin = gray_to_bin ^ (gray_to_bin >> i);
            end
        end
    endfunction

    // Write pointer management
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= bin_to_gray(wptr_bin + 1);
        end
    end

    // Read pointer management
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= bin_to_gray(rptr_bin + 1);
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

    // Full and empty flags
    always @(*) begin
        wfull = (wptr_gray == {~rptr_gray_sync2[PTR_WIDTH-1], rptr_gray_sync2[PTR_WIDTH-2:0]});
        rempty = (rptr_gray == wptr_gray_sync2);
    end

endmodule
