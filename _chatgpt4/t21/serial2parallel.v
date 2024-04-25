module pulse_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic data_in,
    output logic data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        S0 = 2'b01,
        S01 = 2'b10
    } state_t;

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
                    next_state = S0;  // Move to S0 to handle overlapping patterns
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign data_out = (state == S01 && data_in == 1'b0);

endmodule
module serial2parallel(
    input  logic clk,
    input  logic rst_n,
    input  logic din_serial,
    input  logic din_valid,
    output logic [7:0] dout_parallel,
    output logic dout_valid
);

    logic [2:0] cnt; // 3-bit counter to support counting from 0 to 7

    // Register to hold the received serial bits
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
            cnt <= 3'b0;
            dout_valid <= 1'b0;
        end else if (din_valid) begin
            dout_parallel <= (dout_parallel << 1) | din_serial; // Shift left and append new bit
            cnt <= cnt + 1;
            if (cnt == 7) begin
                cnt <= 0;
                dout_valid <= 1'b1; // Output is valid after receiving 8 bits
            end else begin
                dout_valid <= 1'b0;
            end
        end
    end

endmodule
