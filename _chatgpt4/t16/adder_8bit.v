module pulse_detect(
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE, S0, S01
    } state_type;

    // State register
    state_type state = IDLE, next_state = IDLE;

    // State transition logic on the clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        next_state = state;  // Default to hold state unless conditions met to change
        case (state)
            IDLE:
                if (data_in == 0)
                    next_state = S0;
            S0:
                if (data_in == 1)
                    next_state = S01;
            S01:
                next_state = (data_in == 0) ? S0 : IDLE;
            default: 
                next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (state == S01 && data_in == 0)
            data_out <= 1;
        else
            data_out <= 0;
    end

endmodule
module adder_8bit(
    input wire [7:0] a,
    input wire [7:0] b,
    input wire cin,
    output wire [7:0] sum,
    output wire cout
);

    // Intermediate wires for carry bits
    wire [7:0] carry;

    // Full adder logic for each bit with carry chaining
    full_adder fa0(a[0], b[0], cin,    sum[0], carry[0]);
    full_adder fa1(a[1], b[1], carry[0], sum[1], carry[1]);
    full_adder fa2(a[2], b[2], carry[1], sum[2], carry[2]);
    full_adder fa3(a[3], b[3], carry[2], sum[3], carry[3]);
    full_adder fa4(a[4], b[4], carry[3], sum[4], carry[4]);
    full_adder fa5(a[5], b[5], carry[4], sum[5], carry[5]);
    full_adder fa6(a[6], b[6], carry[5], sum[6], carry[6]);
    full_adder fa7(a[7], b[7], carry[6], sum[7], carry[7]);

    // Assign the final carry out
    assign cout = carry[7];

endmodule

module full_adder(
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
);
    assign sum = a ^ b ^ cin;  // Sum calculation
    assign cout = (a & b) | (b & cin) | (a & cin);  // Carry calculation
endmodule
