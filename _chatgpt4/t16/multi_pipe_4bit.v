module pulse_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic data_in,
    output logic data_out
);
    // State encoding definition
    typedef enum logic [1:0] {
        IDLE = 2'b00, 
        S0   = 2'b01, 
        S01  = 2'b10
    } state_t;
    
    // State and next state registers
    state_t state = IDLE, next_state = IDLE;

    // State transition logic with reset condition
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (data_in == 0) ? S0 : IDLE;
            S0: next_state = (data_in == 1) ? S01 : S0;
            S01: next_state = (data_in == 0) ? S0 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign data_out = (state == S01 && data_in == 0);
endmodule
module multi_pipe_4bit(
    input  logic clk,
    input  logic rst_n,
    input  logic [3:0] mul_a,  // 4-bit multiplicand
    input  logic [3:0] mul_b,  // 4-bit multiplier
    output logic [7:0] mul_out // Output of the multiplication (2*size bits)
);

    // To store the partial products and intermediate sums.
    logic [7:0] partial_products [0:3];
    logic [7:0] sums [0:4]; // One extra for the final sum

    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin : PART_PROD
            assign partial_products[i] = mul_b[i] ? (mul_a << i) : 8'b0;
        end
    endgenerate

    // Pipelined addition of partial products
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            sums[0] <= 8'd0;
            sums[1] <= 8'd0;
            sums[2] <= 8'd0;
            sums[3] <= 8'd0;
            sums[4] <= 8'd0;
        end else begin
            sums[0] <= partial_products[0];
            sums[1] <= sums[0] + partial_products[1];
            sums[2] <= sums[1] + partial_products[2];
            sums[3] <= sums[2] + partial_products[3];
            sums[4] <= sums[3];
        end
    end

    // Assign the final sum to output
    assign mul_out = sums[4];
endmodule
