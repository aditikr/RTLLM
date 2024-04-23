module pulse_detect(
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding using parameters for better understanding
    parameter IDLE = 2'b00,
              S0 = 2'b01,
              S01 = 2'b10;

    reg [1:0] state = IDLE;
    reg [1:0] next_state;

    // State register with asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // State transition logic
    always @* begin
        case (state)
            IDLE:
                if (data_in == 1'b0)
                    next_state = S0;
                else
                    next_state = IDLE;
            S0:
                if (data_in == 1'b1)
                    next_state = S01;
                else
                    next_state = S0;
            S01:
                if (data_in == 1'b0)
                    next_state = S0;  // Move to S0 to handle overlapping patterns
                else
                    next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic: Detect the transition to 0 in the S01 state
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 1'b0;
        end else if (state == S01 && data_in == 1'b0) begin
            data_out <= 1'b1;
        end else begin
            data_out <= 1'b0;
        end
    end
endmodule
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
