
module dual_port_RAM #(parameter DEPTH = 16, WIDTH = 8)
(
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    always @(posedge wclk)
    begin
        if(wenc)
            RAM_MEM[waddr] <= wdata;
    end

    always @(posedge rclk)
    begin
        if(renc)
            rdata <= RAM_MEM[raddr];
    end

endmodule

module asyn_fifo #(parameter WIDTH = 8, DEPTH = 16)
(
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

    reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
    reg [$clog2(DEPTH)-1:0] wptr, rptr, wptr_buff, rptr_buff;
    reg [$clog2(DEPTH)-1:0] wptr_syn, rptr_syn;

    // Dual-port RAM instantiation
    dual_port_RAM #(DEPTH, WIDTH) RAM_inst (
        .wclk(wclk),
        .wenc(winc),
        .waddr(wptr_syn),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc),
        .raddr(rptr_syn),
        .rdata(rdata)
    );

    // Write pointer logic
    always @(posedge wclk or negedge wrstn)
    begin
        if(~wrstn)
            wptr <= 0;
        else if(winc)
            wptr <= wptr + 1;
    end

    // Read pointer logic
    always @(posedge rclk or negedge rrstn)
    begin
        if(~rrstn)
            rptr <= 0;
        else if(rinc)
            rptr <= rptr + 1;
    end

    // Gray code conversion for write pointer
    always @(*)
    begin
        wptr_syn = wptr ^ (wptr >> 1);
    end

    // Gray code conversion for read pointer
    always @(*)
    begin
        rptr_syn = rptr ^ (rptr >> 1);
    end

    // Pointer buffer update
    always @(posedge wclk or negedge wrstn)
    begin
        if(~wrstn)
            wptr_buff <= 0;
        else
            wptr_buff <= wptr;
    end

    always @(posedge rclk or negedge rrstn)
    begin
        if(~rrstn)
            rptr_buff <= 0;
        else
            rptr_buff <= rptr;
    end

    // Full and Empty signals
    always @(*)
    begin
        if(wptr == ~({1'b0, rptr_syn[$clog2(DEPTH)-2:0]}))
            wfull = 1;
        else
            wfull = 0;

        if(rptr == wptr)
            rempty = 1;
        else
            rempty = 0;
    end

endmodule
