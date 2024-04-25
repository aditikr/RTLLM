module pulse_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic data_in,
    output logic data_out
);
    // State encoding
    typedef enum logic [1:0] {IDLE = 2'b00, S0 = 2'b01, S01 = 2'b10} state_t;
    state_t state = IDLE, next_state = IDLE;

    // State register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // State transition logic
    always_comb begin
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = S0;
                else
                    next_state = IDLE;
            end
            S0: begin
                if (data_in == 1'b1)
                    next_state = S01;
                else
                    next_state = S0; 
            end
            S01: begin
                if (data_in == 1'b0)
                    next_state = S0; // Move to S0 to handle overlapping patterns.
                else
                    next_state = IDLE;
            end
            default: 
                next_state = IDLE;
        endcase
    end

    // Output logic
    assign data_out = (state == S01 && data_in == 1'b0);
endmodule
module carry_lookahead_adder_16bit(
    input  logic [15:0] A,
    input  logic [15:0] B,
    input  logic Cin,
    output logic [15:0] S,
    output logic Cout
);
    logic [15:0] G; // Generate
    logic [15:0] P; // Propagate
    logic [16:0] C; // Carry

    assign G = A & B;
    assign P = A ^ B;
    assign C[0] = Cin;

    // Carry Calculation
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            assign C[i + 1] = G[i] | (P[i] & C[i]);
        end 
    endgenerate

    // Sum Calculation
    assign S = P ^ C[15:0];
    assign Cout = C[16];
endmodule
module adder_32bit(
    input  logic [31:0] A,
    input  logic [31:0] B,
    output logic [31:0] S,
    output logic C32
);
    logic C16; // Carry out from the first 16-bit adder, serving as Carry in for the second

    carry_lookahead_adder_16bit cla1 (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S[15:0]),
        .Cout(C16)
    );

    carry_lookahead_adder_16bit cla2 (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),
        .S(S[31:16]),
        .Cout(C32)
    );
endmodule
