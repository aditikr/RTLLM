module pulse_detect(
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg data_out
);

    // State definition for FSM
    typedef enum logic [1:0] {
        IDLE = 2'b00, 
        S0 = 2'b01, 
        S01 = 2'b10
    } state_type;

    // State variables
    state_type state = IDLE, next_state = IDLE;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:
                if (data_in == 0)
                    next_state = S0;
                else
                    next_state = IDLE;
            S0:
                if (data_in == 1)
                    next_state = S01;
                else
                    next_state = S0;
            S01:
                if (data_in == 0)
                    next_state = S0;  // Overlap handling
                else
                    next_state = IDLE;
            default:
                next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_out <= 0;
        else
            data_out <= (state == S01 && data_in == 0);
    end
endmodule
module serial2parallel(
    input  wire clk,
    input  wire rst_n,
    input  wire din_serial,
    input  wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] cnt;  // 3-bit counter for counting up to 8

    // Serial to parallel conversion logic
    always @(posedge clk) begin
        if (!rst_n) begin
            dout_parallel <= 0;
            cnt <= 0;
            dout_valid <= 0;
        end else if (din_valid) begin
            dout_parallel <= (dout_parallel << 1) | din_serial;
            cnt <= cnt + 1;
            // Check if 8 bits received
            if (cnt == 7) begin
                dout_valid <= 1;
                cnt <= 0;  // Reset counter for next batch
            end else begin
                dout_valid <= 0;
            end
        end
    end
endmodule
