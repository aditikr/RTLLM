module freq_div(
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Counter for CLK_10 and CLK_1
    reg [3:0] cnt_10;  // Counter must go from 0 to 9 for 10MHz clock
    reg [6:0] cnt_100; // Counter must go from 0 to 99 for 1MHz clock

    // CLK_50 generation (Toggle every CLK_in edge)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 0;
            CLK_10 <= 0;
        end else if (cnt_10 == 4) begin
            CLK_10 <= ~CLK_10; // Toggle CLK_10 every 5th tick to achieve division by 10
            cnt_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
    end

    // CLK_1 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 0;
            CLK_1 <= 0;
        end else if (cnt_100 == 49) begin
            CLK_1 <= ~CLK_1; // Toggle CLK_1 every 50th tick to achieve division by 100
            cnt_100 <= 0;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end

endmodule
