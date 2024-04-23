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
                if (data_in == 1'b0)
                    next_state = S0;
                else
                    next_state = IDLE;
            end
            S0: begin
                if (data_in == 1'b1)
                    next_state = S01;
                else
                    next_state = S0; // Stay in S0 if data_in remains 0
            end
            S01: begin
                if (data_in == 1'b0)
                    next_state = S0; // Move to S0 to handle overlapping patterns
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
        end else begin
            data_out <= (state == S01 && data_in == 1'b0);
        end
    end
endmodule
module right_shifter(
    input  logic clk,
    input  logic d,
    output logic [7:0] q
);

    // Register definition and initialization
    initial begin
        q = 8'b0;
    end

    // Right shift operation on rising clock edge
    always @(posedge clk) begin
        q <= {d, q[7:1]}; // Shift right by one position and insert d at MSB
    end
endmodule
