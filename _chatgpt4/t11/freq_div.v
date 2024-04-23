module freq_div(
    input CLK_in,  // Input clock signal
    input RST,     // Reset signal
    output reg CLK_50,  // Output clock signal with frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with frequency of CLK_in divided by 10
    output reg CLK_1    // Output clock signal with frequency of CLK_in divided by 100
);

// Internal counters for CLK_10 and CLK_1
reg [2:0] cnt_10;  // 3-bit counter for dividing by 10
reg [6:0] cnt_100; // 7-bit counter for dividing by 100

// CLK_50 generation
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
    end else begin
        CLK_50 <= ~CLK_50;
    end
end

// CLK_10 generation
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

// CLK_1 generation
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
