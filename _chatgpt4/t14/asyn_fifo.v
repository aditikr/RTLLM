module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
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

// Internal RAM module
dual_port_RAM #(WIDTH, DEPTH) ram_inst (
    .wclk(wclk),
    .wenc(winc & ~wfull),
    .waddr(wptr_bin[ADDR_WIDTH-1:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc & ~rempty),
    .raddr(rptr_bin[ADDR_WIDTH-1:0]),
    .rdata(rdata)
);

// Write and read pointer logic
reg [ADDR_WIDTH:0] wptr, rptr;
reg [ADDR_WIDTH:0] wptr_bin, rptr_bin;

// Synchronization stages
reg [ADDR_WIDTH:0] wptr_syn, rptr_syn;

// Pointer Logic
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wptr <= 0;
        wptr_bin <= 0;
    end else if (winc && !wfull) begin
        wptr <= wptr + 1;
        wptr_bin <= wptr_bin + 1;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rptr <= 0;
        rptr_bin <= 0;
    end else if (rinc && !rempty) begin
        rptr <= rptr + 1;
        rptr_bin <= rptr_bin + 1;
    end
end

// Gray encoding
function [ADDR_WIDTH:0] bin_to_gray(input [ADDR_WIDTH:0] bin);
    bin_to_gray = bin ^ (bin >> 1);
endfunction

// Synchronization Logic
always @(posedge wclk) begin
    rptr_syn <= rptr;
end

always @(posedge rclk) begin
    wptr_syn <= wptr;
end

// Full and empty logic
always @(*) begin
    rempty = (rptr == wptr_syn);
    wfull = (wptr_bin[ADDR_WIDTH-1:0] == {~rptr_syn[ADDR_WIDTH:ADDR_WIDTH-1], rptr_syn[ADDR_WIDTH-2:0]} + 1);
end

endmodule

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] RAM_MEM[0:DEPTH-1];

always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule
