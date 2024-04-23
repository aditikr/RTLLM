module calendar(
    input  wire CLK,
    input  wire RST,
    output reg [5:0] Hours = 0,
    output reg [5:0] Mins = 0,
    output reg [5:0] Secs = 0
);

    // Handling seconds increment and wrap-around
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 0;
        end else if (Secs == 59) begin
            Secs <= 0;
        end else begin
            Secs <= Secs + 1;
        end
    end

    // Handling minutes increment and wrap-around
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

    // Handling hours increment and wrap-around
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
