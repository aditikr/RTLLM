module pulse_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic data_in,
    output logic data_out
);

    // State encoding
    typedef enum logic [1:0] {IDLE, S0, S01} state_t;
    state_t state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
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

    logic [2:0] cnt;
    logic [7:0] shift_reg;

    // Shift the serial data into a parallel register
    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
            cnt <= 3'b0;
            dout_valid <= 1'b0;
        end else if (din_valid) begin
            shift_reg <= (shift_reg << 1) | din_serial;
            if (cnt == 3'b111) begin
                cnt <= 3'b0;
                dout_valid <= 1'b1;
            end else begin
                cnt <= cnt + 1;
                dout_valid <= 1'b0;
            end
        end else begin
            dout_valid <= 1'b0;
        end
    end

    // Assign the parallel output
    assign dout_parallel = shift_reg;

endmodule
