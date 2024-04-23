module freq_div(
    input wire CLK_in,   // Input clock (100 MHz)
    input wire RST,      // Asynchronous reset
    output reg CLK_50,   // Output clock 50 MHz
    output reg CLK_10,   // Output clock 10 MHz
    output reg CLK_1     // Output clock 1 MHz
);

    // Define internal counters
    reg [2:0] cnt_10;   // Counter for 10 MHz clock (counts 0 to 4)
    reg [6:0] cnt_100;  // Counter for 1 MHz clock (counts 0 to 49)

    // Initial block for reset conditions
    initial begin
        CLK_50 = 0;
        CLK_10 = 0;
        CLK_1 = 0;
        cnt_10 = 0;
        cnt_100 = 0;
    end

    // Clock generation logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset conditions for all clocks
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
            cnt_10 <= 0;
            cnt_100 <= 0;
        end else begin
            // CLK_50 generation (Toggle on each edge)
            CLK_50 <= ~CLK_50;

            // CLK_10 generation
            if (cnt_10 == 4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 0;  // Reset counter when it reaches 4
            end else begin
                cnt_10 <= cnt_10 + 1;
            end

            // CLK_1 generation
            if (cnt_100 == 49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 0;  // Reset counter when it reaches 49
            end else begin
                cnt_100 <= cnt_100 + 1;
            end
        end
    end

endmodule
