module freq_div(
    input  CLK_in,
    input  RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

// Declare counters
reg [3:0] cnt_10;  // Counter for 10 MHz clock
reg [6:0] cnt_100; // Counter for 1 MHz clock

// Generate CLK_50 (50 MHz clock)
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
    end else begin
        CLK_50 <= !CLK_50;
    end
end

// Generate CLK_10 (10 MHz clock)
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_10 <= 0;
        cnt_10 <= 0;
    end else begin
        if (cnt_10 == 4) begin
            CLK_10 <= !CLK_10;
            cnt_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
    end
end

// Generate CLK_1 (1 MHz clock)
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_1 <= 0;
        cnt_100 <= 0;
    end else begin
        if (cnt_100 == 49) begin
            CLK_1 <= !CLK_1;
            cnt_100 <= 0;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule
