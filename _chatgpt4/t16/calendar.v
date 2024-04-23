module calendar(
    input  wire CLK,
    input  wire RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Seconds update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 0;
    end else if (Secs == 59) begin
        Secs <= 0;
    end else begin
        Secs <= Secs + 1;
    end
end

// Minutes update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 0;
    end else if (Secs == 59) begin
        if (Mins == 59) begin
            Mins <= 0;
        end else begin
            Mins <= Mins + 1;
        end
    end
end

// Hours update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 0;
    end else if (Secs == 59 && Mins == 59) begin
        if (Hours == 23) begin
            Hours <= 0;
        end else begin
            Hours <= Hours + 1;
        end
    end
end

endmodule
