module calendar (
    input logic CLK,
    input logic RST,
    output logic [5:0] Hours,
    output logic [5:0] Mins,
    output logic [5:0] Secs
);

    // Initialize the Secs, Mins, and Hours
    always_ff @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'd0;
        end else if (Secs == 6'd59) begin
            Secs <= 6'd0;
        end else begin
            Secs <= Secs + 1;
        end
    end

    // Control the Mins register
    always_ff @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'd0;
        end else if (Secs == 6'd59) begin
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
            end else begin
                Mins <= Mins + 1;
            end
        end 
    end

    // Control the Hours register
    always_ff @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'd0;
        end else if ((Mins == 6'd59) && (Secs == 6'd59)) begin
            if (Hours == 6'd23) begin
                Hours <= 6'd0;
            end else begin
                Hours <= Hours + 1;
            end
        end
    end

endmodule
