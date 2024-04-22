
module signal_generator(
    input clk,        // Clock signal
    input rst_n,      // Active-low reset signal
    output reg [4:0] wave  // 5-bit output waveform signal
);

    // State register to control the waveform generation
    reg state;  // 0 for incrementing, 1 for decrementing

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            wave <= 5'd0;  // Reset wave to 0
            state <= 1'b0; // Set state to incrementing
        end else begin
            case (state)
                1'b0: begin
                    // State 0: Increment wave
                    if (wave == 5'd31) begin
                        state <= 1'b1; // Change state to decrementing
                    end else begin
                        wave <= wave + 1'b1; // Increment wave
                    end
                end
                1'b1: begin
                    // State 1: Decrement wave
                    if (wave == 5'd0) begin
                        state <= 1'b0; // Change state to incrementing
                    end else begin
                        wave <= wave - 1'b1; // Decrement wave
                    end
                end
            endcase
        end
    end

endmodule
