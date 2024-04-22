module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State encoding
    localparam IDLE = 2'b00,
               HIGH = 2'b01,
               DETECT = 2'b10;

    // State registers
    reg [1:0] state = IDLE;
    reg [1:0] next_state = IDLE;
    reg last_data_in;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            last_data_in <= 0;
            data_out <= 0;
        end else begin
            state <= next_state;
            last_data_in <= data_in;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (last_data_in == 0 && data_in == 1)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (last_data_in == 1 && data_in == 0)
                    next_state = DETECT;
                else
                    next_state = HIGH;
            end
            DETECT: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (state == DETECT)
            data_out <= 1;
        else
            data_out <= 0;
    end

endmodule
