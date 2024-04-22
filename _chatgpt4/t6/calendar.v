
module calendar(
    input CLK,       // Clock input
    input RST,       // Active high reset signal
    output reg [5:0] Hours,  // 6-bit output for hours (0-23)
    output reg [5:0] Mins,   // 6-bit output for minutes (0-59)
    output reg [5:0] Secs    // 6-bit output for seconds (0-59)
);

// Initialize the outputs
initial begin
    Hours = 6'd0;
    Mins = 6'd0;
    Secs = 6'd0;
end

// Seconds handling
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else if (Secs == 59) begin
        Secs <= 6'd0;
    end else begin
        Secs <= Secs + 1;
    end
end

// Minutes handling
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (Secs == 59) begin
        if (Mins == 59) begin
            Mins <= 6'd0;
        end else begin
            Mins <= Mins + 1;
        end
    end
end

// Hours handling
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if (Secs == 59 && Mins == 59) begin
        if (Hours == 23) begin
            Hours <= 6'd0;
        end else begin
            Hours <= Hours + 1;
        end
    end
end

endmodule
