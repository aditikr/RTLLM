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
            state <= IDLE; // Reset to IDLE state
        end else begin
            state <= next_state; // Update state
        end
    end

    // State transition logic
    always_comb begin
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = S0; // Got 0, move to S0
                else
                    next_state = IDLE;
            end
            S0: begin
                if (data_in == 1'b1)
                    next_state = S01; // Got 1 after 0, move to S01
                else
                    next_state = S0;
            end
            S01: begin
                if (data_in == 1'b0)
                    next_state = S0; // Got 0 after 01, look for next 0 in 010
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign data_out = (state == S01 && data_in == 1'b0); // Output 1 on 010
endmodule
module signal_generator(
    input  logic clk,
    input  logic rst_n,
    output logic [4:0] wave
);

    logic state; // 0 for incrementing, 1 for decrementing
    logic [4:0] wave_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave_reg <= 0;
            state <= 0; // Start with incrementing
        end else begin
            if (state == 0) begin // Incrementing state
                if (wave_reg == 31) begin
                    state <= 1; // Switch to decrementing
                end else begin
                    wave_reg <= wave_reg + 1;
                end
            end else begin // Decrementing state
                if (wave_reg == 0) begin
                    state <= 0; // Switch to incrementing
                end else begin
                    wave_reg <= wave_reg - 1;
                end
            end
        end
    end

    assign wave = wave_reg; // Assign the internal register to the output

endmodule
