module pulse_detect(
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        S0   = 2'b01,
        S01  = 2'b10
    } state_t;

    reg state, next_state;

    // State transition and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state; // Default to hold current state
        case (state)
            IDLE:
                if (data_in == 0)
                    next_state = S0;
            S0:
                if (data_in == 1)
                    next_state = S01;
                else
                    next_state = S0;
            S01:
                if (data_in == 0)
                    next_state = S0; // Handle overlapping patterns
                else
                    next_state = IDLE;
        endcase
    end

    // Determine pulse detection
    always @(posedge clk) begin
        if (state == S01 && data_in == 0)
            data_out <= 1;
        else
            data_out <= 0;
    end

endmodule
module adder_8bit(
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire Cin,
    output wire [7:0] y,
    output wire Co
);
    // Implementing the 8-bit adder using Verilog's built-in addition
    assign {Co, y} = a + b + Cin;
endmodule

module adder_16bit(
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire Cin,
    output wire [15:0] y,
    output wire Co
);
    wire c_mid; // Intermediate carry

    // Instantiating the first 8-bit adder
    adder_8bit lower_half (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(c_mid)
    );

    // Instantiating the second 8-bit adder
    adder_8bit upper_half (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c_mid),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule
