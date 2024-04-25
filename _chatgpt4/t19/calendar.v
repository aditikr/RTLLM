module pulse_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic data_in,
    output logic data_out
);

    // State declaration
    typedef enum logic [1:0] {
        IDLE, // Waiting for the start of the sequence
        S0,   // Detected a '0'
        S01   // Detected '01'
    } state_t;

    // State register
    state_t state = IDLE, next_state;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        case (state)
            IDLE: next_state = (data_in == 0) ? S0 : IDLE;
            S0:   next_state = (data_in == 1) ? S01 : S0;
            S01:  next_state = (data_in == 0) ? S0 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign data_out = (state == S01 && data_in == 0);

endmodule
module calendar(
    input wire CLK,      // Clock input
    input wire RST,      // Active high reset input
    output reg [5:0] Hours = 0,  // Hours output
    output reg [5:0] Mins = 0,   // Minutes output
    output reg [5:0] Secs = 0    // Seconds output
);

    // Seconds update logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 0;
        end else if (Secs == 59) begin
            Secs <= 0;
        end else begin
            Secs <= Secs + 1;
        end
    end

    // Minutes update logic
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

    // Hours update logic
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
