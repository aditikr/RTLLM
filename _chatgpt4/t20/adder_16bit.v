module pulse_detect(
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output logic data_out
);

    // State encoding
    typedef enum logic [1:0] {IDLE, S0, S01} state_t;
    state_t state = IDLE, next_state;

    // State register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // State transition logic
    always_comb begin
        case(state)
            IDLE: next_state <= data_in ? IDLE : S0;
            S0:   next_state <= data_in ? S01 : S0;
            S01:  next_state <= data_in ? IDLE : S0;
            default: next_state <= IDLE;
        endcase
    end

    // Output logic
    always_comb begin
        data_out = (state == S01 && !data_in);
    end

endmodule
module adder_8bit(
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire Cin,
    output wire [7:0] y,
    output wire Co
);
    // 8-bit addition
    assign {Co, y} = a + b + Cin;
endmodule
module adder_16bit(
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire Cin,
    output wire [15:0] y,
    output wire Co
);
    wire C_mid;

    // First 8-bit adder (LSBs)
    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(C_mid)
    );

    // Second 8-bit adder (MSBs) with carry in from first adder
    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(C_mid),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule
