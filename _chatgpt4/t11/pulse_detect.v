module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State declaration
reg [1:0] state;
reg [1:0] next_state;

// State encoding
localparam S0 = 2'b00; // Waiting for 0->1 transition
localparam S1 = 2'b01; // Waiting for 1->0 transition
localparam S2 = 2'b10; // Pulse detected, output high

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S0;
        data_out <= 1'b0;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        S0: begin
            if (data_in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
            data_out = 1'b0;
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
            data_out = 1'b0;
        end
        S2: begin
            next_state = S0;
            data_out = 1'b1;
        end
        default: begin
            next_state = S0;
            data_out = 1'b0;
        end
    endcase
end

endmodule
