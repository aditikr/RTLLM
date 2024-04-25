module freq_div(
    input  wire CLK_in, // Input clock at 100MHz
    input  wire RST,    // Asynchronous reset
    output reg  CLK_50, // Output clock at 50MHz
    output reg  CLK_10, // Output clock at 10MHz
    output reg  CLK_1   // Output clock at 1MHz
);

    // Clock divider counters
    reg [3:0] cnt_10;
    reg [6:0] cnt_100;

    // Generate CLK_50
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Generate CLK_10
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 4'd0;
        end else if (cnt_10 == 4'd4) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 4'd0;
        end else begin
            cnt_10 <= cnt_10 + 4'd1;
        end
    end

    // Generate CLK_1
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 7'd0;
        end else if (cnt_100 == 7'd49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 7'd0;
        end else begin
            cnt_100 <= cnt_100 + 7'd1;
        end
    end

endmodule
