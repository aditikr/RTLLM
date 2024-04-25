module signal_generator(
    input  logic clk,
    input  logic rst_n,
    output logic [4:0] wave  // 5-bit output
);

    // State definitions
    typedef enum logic {INCREASING, DECREASING} State;
    State state;

    // Waveform register
    logic [4:0] wave;

    // Always block for state and waveform updates
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave <= 5'd0;
            state <= INCREASING;
        end else begin
            case (state)
                INCREASING: begin
                    if (wave == 5'd31) begin
                        state <= DECREASING;
                    end else begin
                        wave <= wave + 1;
                    end
                end
                DECREASING: begin
                    if (wave == 5'd0) begin
                        state <= INCREASING;
                    end else begin
                        wave <= wave - 1;
                    end
                end
                default: begin
                    state <= INCREASING;
                    wave <= 5'd0;
                end
            endcase
        end
    end

    // Output assignment
    assign wave = wave;

endmodule
