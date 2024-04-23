module signal_generator(
    input wire clk,       // Clock input
    input wire rst_n,     // Active-low reset input
    output reg [4:0] wave // 5-bit wave output
);

    // State definition: 0 for incrementing, 1 for decrementing
    reg state;

    // Sequential logic for edge-triggered state and output updates
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            wave <= 5'b00000;  // Reset wave to 0
            state <= 1'b0;     // Start with incrementing state
        end else begin
            // Normal operation
            case (state)
                1'b0: begin // State 0: Incrementing
                    if (wave == 5'b11111) begin
                        // If wave reaches 31, switch to decrementing
                        state <= 1'b1;
                    end else begin
                        // Otherwise, increment wave
                        wave <= wave + 1;
                    end
                end
                1'b1: begin // State 1: Decrementing
                    if (wave == 5'b00000) begin
                        // If wave reaches 0, switch to incrementing
                        state <= 1'b0;
                    end else begin
                        // Otherwise, decrement wave
                        wave <= wave - 1;
                    end
                end
            endcase
        end
    end
endmodule
