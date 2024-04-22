module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Define counters for different frequencies
    reg [3:0] cnt_10;  // 4-bit counter for 10MHz clock
    reg [6:0] cnt_100; // 7-bit counter for 1MHz clock

    // Initialize the output clocks and counters
    initial begin
        CLK_50 = 0;
        CLK_10 = 0;
        CLK_1 = 0;
        cnt_10 = 0;
        cnt_100 = 0;
    end

    // CLK_50 Generation: Toggle every clock cycle
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 Generation: Toggle every 10 cycles
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

    // CLK_1 Generation: Toggle every 100 cycles
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
