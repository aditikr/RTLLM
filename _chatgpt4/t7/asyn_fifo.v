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
    // Pointer definitions
    reg [$clog2(DEPTH)-1:0] wptr_bin = 0, rptr_bin = 0;
    reg [$clog2(DEPTH):0] wptr_gray = 0, rptr_gray = 0;
    reg [$clog2(DEPTH):0] wptr_gray_sync1, wptr_gray_sync2;
    reg [$clog2(DEPTH):0] rptr_gray_sync1, rptr_gray_sync2;

    // Instantiate dual-port RAM
    dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram (
        .wclk(wclk),
        .wenc(winc && !wfull),
        .waddr(wptr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc && !rempty),
        .raddr(rptr_bin),
        .rdata(rdata)
    );

    // Binary to Gray conversion
    function [$clog2(DEPTH):0] bin_to_gray(input [$clog2(DEPTH)-1:0] bin);
        bin_to_gray = (bin >> 1) ^ bin;
    endfunction

    // Gray to Binary conversion
    function [$clog2(DEPTH)-1:0] gray_to_bin(input [$clog2(DEPTH):0] gray);
        integer i;
        begin
            gray_to_bin = gray;
            for (i = 1; i < $clog2(DEPTH); i = i * 2) begin
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

    // Synchronize write pointer to read clock domain
    always @(posedge rclk) begin
        wptr_gray_sync1 <= wptr_gray;
        wptr_gray_sync2 <= wptr_gray_sync1;
    end

    // Synchronize read pointer to write clock domain
    always @(posedge wclk) begin
        rptr_gray_sync1 <= rptr_gray;
        rptr_gray_sync2 <= rptr_gray_sync1;
    end

    // Full and empty logic
    always @(*) begin
        wfull = (wptr_gray == {~rptr_gray_sync2[$clog2(DEPTH):$clog2(DEPTH)-1], rptr_gray_sync2[$clog2(DEPTH)-2:0]});
        rempty = (rptr_gray == wptr_gray_sync2);
    end
endmodule
