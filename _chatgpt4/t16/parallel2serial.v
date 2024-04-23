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

    // State transition and output logic
    always_comb begin
        // Default assignment
        next_state = state;
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = S0;
            end
            S0: begin
                if (data_in == 1'b1)
                    next_state = S01;
            end
            S01: begin
                if (data_in == 1'b0)
                    next_state = S0;  // Move to S0 to handle overlapping patterns
            end
            default: next_state = IDLE;
        endcase
    end

    // Output assignment
    assign data_out = (state == S01 && data_in == 1'b0);

endmodule
module parallel2serial(
    input  logic clk,
    input  logic rst_n,
    input  logic [3:0] d,
    output logic valid_out,
    output logic dout
);

    reg [2:0] cnt; // Counter tracking which bit is being output
    reg [3:0] data; // Data register holding the current parallel data

    // Operations at the positive edge of clock or on reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b0; // Reset counter
            valid_out <= 1'b0; // Reset valid flag
            data <= 4'b0; // Clear the data register
        end else begin
            if (cnt == 3'b0) begin
                data <= d; // Load new data
                valid_out <= 1'b1; // Valid output available
                cnt <= cnt + 1; // Increment counter
            end else if (cnt <= 3'b011) begin
                valid_out <= 1'b1; // Continue marking output as valid
                cnt <= cnt + 1; // Increment counter
            end else begin 
                valid_out <= 1'b0; // No more data to output
                cnt <= 3'b0; // Reset counter
            end
        end
    end

    // Assign the serial output from the most significant bit
    assign dout = data[3 - cnt];

endmodule
