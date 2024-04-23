module pulse_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic data_in,
    output logic data_out
);
    enum logic [1:0] {IDLE, S0, S01} state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        case (state)
            IDLE: begin
                next_state = (data_in == 1'b0) ? S0 : IDLE;
            end
            S0: begin
                next_state = (data_in == 1'b1) ? S01 : S0;
            end
            S01: begin
                next_state = (data_in == 1'b0) ? S0 : IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    assign data_out = (state == S01) && (data_in == 1'b0);
endmodule
module JC_counter(
    input  logic clk,
    input  logic rst_n,
    output logic [63:0] Q
);
    // Johnson counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 64'b0;
        end else begin
            if (Q[0] == 1'b0) begin
                Q <= {1'b1, Q[63:1]};
            end else begin
                Q <= {1'b0, Q[63:1]};
            end
        end
    end
endmodule
