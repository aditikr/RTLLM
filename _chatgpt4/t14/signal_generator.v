module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

    // Define state register (0 for incrementing, 1 for decrementing)
    reg state;

    // Always block for handling positive edge of clock or negative edge of reset
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin // Active low reset
            wave <= 5'd0;  // Reset wave value to 0
            state <= 0;    // Start with incrementing state
        end else begin
            case (state)
                0: begin // Incrementing state
                    if (wave == 31) begin
                        state <= 1; // Switch to decrementing
                    end else begin
                        wave <= wave + 1; // Increment wave
                    end
                end
                1: begin // Decrementing state
                    if (wave == 0) begin
                        state <= 0; // Switch back to incrementing
                    end else begin
                        wave <= wave - 1; // Decrement wave
                    end
                end
            endcase
        end
    end
endmodule
