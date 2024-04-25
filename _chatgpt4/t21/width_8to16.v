module pulse_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic data_in,
    output logic data_out
);

    // State encoding
    enum logic [1:0] {IDLE, S0, S01} state, next_state;

    // State register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            state <= IDLE;
        else 
            state <= next_state;
    end

    // State transition logic
    always_comb begin
        case (state)
            IDLE: 
                next_state = (data_in == 1'b0) ? S0 : IDLE;
            S0: 
                next_state = (data_in == 1'b1) ? S01 : S0;
            S01: 
                next_state = (data_in == 1'b0) ? S0 : IDLE;
            default: 
                next_state = IDLE;
        endcase
    end

    // Output logic
    assign data_out = (state == S01) && (data_in == 1'b0);

endmodule
module width_8to16(
    input        clk,
    input        rst_n,
    input        valid_in,
    input  [7:0] data_in,
    output logic valid_out,
    output logic [15:0] data_out
);

    logic [7:0] data_lock;      // Lock register to store the first 8 bits
    logic       lock_valid;     // Flag to indicate data_lock is filled and waiting for second byte

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 16'b0;
            valid_out <= 1'b0;
            data_lock <= 8'b0;
            lock_valid <= 1'b0;
        end else if (valid_in) begin
            if (lock_valid) begin
                // Combine the locked data with new data_in to form 16-bit output
                data_out <= {data_lock, data_in};
                valid_out <= 1'b1;
                lock_valid <= 1'b0; // reset lock flag after combining
            end else begin
                data_lock <= data_in;   // Store incoming data
                lock_valid <= 1'b1;    // Indicate that data_lock is valid
                valid_out <= 1'b0;     // No output yet
            end
        end
    end

endmodule
