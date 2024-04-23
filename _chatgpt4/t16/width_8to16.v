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
                    next_state = S0;
            end
            S01: begin
                if (data_in == 1'b0)
                    next_state = S0;  // Move to S0 to handle overlapping patterns
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign data_out = (state == S01 && data_in == 1'b0);
endmodule
module width_8to16 (
    input  logic clk,
    input  logic rst_n,
    input  logic valid_in,
    input  logic [7:0] data_in,
    output logic valid_out,
    output logic [15:0] data_out
);

    // Internal registers to hold data and control flags
    logic [7:0] first_data;
    logic first_data_valid;

    // Data output control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
            valid_out <= 0;
            first_data <= 0;
            first_data_valid <= 0;
        end else begin
            if (valid_in) begin
                if (first_data_valid) begin
                    // Concatenate the first and the second data inputs
                    data_out <= {first_data, data_in};
                    valid_out <= 1;
                    first_data_valid <= 0; // Reset the flag after output
                end else begin
                    // Store the first data
                    first_data <= data_in;
                    first_data_valid <= 1;
                    valid_out <= 0;
                end
            end else begin
                valid_out <= 0;
            end
        end
    end

    // Reset logic in case needed explicitly outside of always block
    always @(negedge rst_n) begin
        data_out <= 16'd0;
        valid_out <= 0;
        first_data_valid <= 0;
    end

endmodule
