module freq_div(
    input CLK_in,  // Input clock signal
    input RST,     // Reset signal
    output reg CLK_50,  // Output clock signal divided by 2 (50MHz)
    output reg CLK_10,  // Output clock signal divided by 10 (10MHz)
    output reg CLK_1    // Output clock signal divided by 100 (1MHz)
);

reg [3:0] cnt_10;       // Counter for generating 10 MHz clock
reg [6:0] cnt_100;      // Counter for generating 1 MHz clock

// CLK_50 Generation
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
    end else begin
        CLK_50 <= ~CLK_50;
    end
end

// CLK_10 Generation
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_10 <= 0;
        cnt_10 <= 0;
    end else begin
        if (cnt_10 == 4) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
    end
end

// CLK_1 Generation
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_1 <= 0;
        cnt_100 <= 0;
    end else begin
        if (cnt_100 == 49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule
