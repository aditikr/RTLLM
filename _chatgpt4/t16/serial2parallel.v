module pulse_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic data_in,
    output logic data_out
);

    // State encoding
    enum logic [1:0] {IDLE, S0, S01} state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
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
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_out <= 1'b0;
        else
            data_out <= (state == S01 && data_in == 1'b0);
    end
endmodule
module serial2parallel(
    input  logic clk,
    input  logic rst_n,
    input  logic din_serial,
    input  logic din_valid,
    output logic [7:0] dout_parallel,
    output logic dout_valid
);

    // Counter for tracking received bits
    logic [2:0] cnt;
    // Temporary register for assembly of received bits
    logic [7:0] shift_reg;

    // Reset logic and counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            shift_reg <= 0;
            dout_valid <= 0;
        end else begin
            if (din_valid) begin
                shift_reg <= (shift_reg << 1) | din_serial;
                cnt <= cnt + 1;
                if (cnt == 7) begin
                    cnt <= 0;
                    dout_parallel <= shift_reg;
                    dout_valid <= 1;
                end else
                    dout_valid <= 0;
            end
        end
    end
endmodule
