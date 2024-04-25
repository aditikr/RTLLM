module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours = 0,
    output reg [5:0] Mins = 0,
    output reg [5:0] Secs = 0
);

// Always block for handling Secs
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset the Seconds to 0 if reset is active
        Secs <= 6'd0;
    end else if (Secs == 59) begin
        // Wrap around if Seconds is at max and increment Mins
        Secs <= 6'd0;
    end else begin
        // Increment Seconds regularly
        Secs <= Secs + 1;
    end
end

// Always block for handling Mins
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset the Minutes to 0 if reset is active
        Mins <= 6'd0;
    end else if (Secs == 59 && Mins == 59) begin
        // Wrap around if Minutes is at max and increment Hours
        Mins <= 6'd0;
    end else if (Secs == 59) begin
        // Increment Minutes if Seconds just wrapped around
        Mins <= Mins + 1;
    end
end

// Always block for handling Hours
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset the Hours to 0 if reset is active
        Hours <= 6'd0;
    end else if (Secs == 59 && Mins == 59 && Hours == 23) begin
        // Wrap around if Seconds, Minutes and Hours are at max
        Hours <= 6'd0;
    end else if (Secs == 59 && Mins == 59) begin
        // Increment Hours if Minutes just wrapped around
        Hours <= Hours + 1;
    end
end

endmodule
