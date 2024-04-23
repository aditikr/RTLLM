module pulse_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic data_in,
    output logic data_out
);

    // State encoding
    enum logic [1:0] {IDLE, S0, S01} state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // State transition logic
    always_comb begin
        case (state)
            IDLE: begin
                next_state = (data_in == 1'b0) ? S0 : IDLE;
            end
            S0: begin
                next_state = (data_in == 1'b1) ? S01 : S0;
            end
            S01: begin
                next_state = (data_in == 1'b0) ? S0 : IDLE;  // Move to S0 for overlapping or back to IDLE
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign data_out = (state == S01 && data_in == 1'b0);
    
endmodule
module counter_12(
    input logic rst_n,
    input logic clk,
    input logic valid_count,
    output logic [3:0] out
);

    // State register for counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 4'b0000;
        end else if (valid_count) begin
            if (out == 4'd11) begin
                out <= 4'b0000; // Wrap around to 0 after reaching max count 
            end else begin
                out <= out + 1;
            end
        end
    end

endmodule
