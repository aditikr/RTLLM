module pulse_detect(
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    // State encoding as two bit register
    reg [1:0] state, next_state;

    // State definitions
    localparam IDLE = 2'b00, S0 = 2'b01, S01 = 2'b10;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // State transition logic
    always @* begin
        next_state = state; // Default to hold state unless conditions met below
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = S0;
            end
            S0: begin
                if (data_in == 1'b1)
                    next_state = S01;
                else
                    next_state = S0;
            end
            S01: begin
                if (data_in == 1'b0)
                    next_state = S0;  // Return to S0 for potential overlap
                else
                    next_state = IDLE;
            end
        endcase
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 1'b0;
        end else begin
            data_out <= (state == S01 && data_in == 1'b0);
        end
    end
endmodule
module signal_generator(
    input wire clk,
    input wire rst_n,
    output reg [4:0] wave
);

    reg state; // 0 for incrementing, 1 for decrementing

    // Waveform generation logicblock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave <= 5'b0;
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: begin
                    if (wave == 5'd31) begin
                        state <= 1'b1;
                        wave <= wave - 5'd1;
                    end else begin
                        wave <= wave + 5'd1;
                    end
                end
                1'b1: begin
                    if (wave == 5'd0) begin
                        state <= 1'b0;
                        wave <= wave + 5'd1;
                    end else begin
                        wave <= wave - 5'd1;
                    end
                end
            endcase
        end
    end
endmodule
