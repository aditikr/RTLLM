module pulse_detect(
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        S0   = 2'b01,
        S01  = 2'b10
    } state_t;

    reg state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:
                if (data_in == 1'b0)
                    next_state = S0;
                else
                    next_state = IDLE;

            S0:
                if (data_in == 1'b1)
                    next_state = S01;
                else
                    next_state = S0; 

            S01:
                if (data_in == 1'b0)
                    next_state = S0;  // Move to S0 to handle overlapping patterns
                else
                    next_state = IDLE;

            default:
                next_state = IDLE;
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
module signal_generator(
    input wire clk,
    input wire rst_n,
    output reg [4:0] wave
);

    // State definitions
    reg state;

    // Waveform and state update logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave <= 5'b00000;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (wave < 5'd31)
                        wave <= wave + 1;
                    else
                        state <= 1;
                end

                1: begin
                    if (wave > 5'd0)
                        wave <= wave - 1;
                    else
                        state <= 0;
                end

                default:
                    state <= 0;
            endcase
        end
    end

endmodule
