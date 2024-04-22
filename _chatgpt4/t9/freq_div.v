module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Internal counters
    reg [2:0] cnt_10;  // 3-bit counter for 10MHz (counts 0 to 4)
    reg [5:0] cnt_100; // 6-bit counter for 1MHz (counts 0 to 49)

    // Initialize the outputs and counters
    initial begin
        CLK_50 = 0;
        CLK_10 = 0;
        CLK_1 = 0;
        cnt_10 = 0;
        cnt_100 = 0;
    end

    // Clock divider logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset all outputs and counters
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
            cnt_10 <= 0;
            cnt_100 <= 0;
        end else begin
            // CLK_50: Toggle every clock cycle
            CLK_50 <= ~CLK_50;

            // CLK_10: Toggle every 5 cycles of CLK_in
            if (cnt_10 == 4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 0;
            end else begin
                cnt_10 <= cnt_10 + 1;
            end

            // CLK_1: Toggle every 50 cycles of CLK_in
            if (cnt_100 == 49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 0;
            end else begin
                cnt_100 <= cnt_100 + 1;
            end
        end
    end

endmodule
