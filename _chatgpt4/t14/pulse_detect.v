module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // Define the State Encoding
    localparam [1:0] 
        S0 = 2'b00,  // Initial state or most recent bit was a 0
        S1 = 2'b01,  // Most recent bit was a 1 after a 0
        S2 = 2'b10;  // Detected a 0 after 01 sequence

    // State register
    reg [1:0] state = S0;

    // Next state logic and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S0;
            data_out <= 0;
        end else begin
            case (state)
                S0: begin
                    data_out <= 0;
                    if (data_in == 1)
                        state <= S1;
                    else
                        state <= S0;
                end
                S1: begin
                    data_out <= 0;
                    if (data_in == 0)
                        state <= S2;
                    else
                        state <= S1;
                end
                S2: begin
                    if (data_in == 1) begin
                        data_out <= 1;  // Here, a 010 pattern is complete
                        state <= S1;
                    end else begin
                        data_out <= 0;
                        state <= S0;
                    end
                end
                default: begin
                    state <= S0;
                    data_out <= 0;
                end
            endcase
        end
    end

endmodule
