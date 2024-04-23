module accu (
    input logic clk,
    input logic rst_n,
    input logic [7:0] data_in,
    input logic valid_in,
    output logic valid_out,
    output logic [9:0] data_out
);

    // Internal registers
    logic [9:0] sum;
    logic [2:0] counter;

    // Reset and processing logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum <= 10'b0;
            counter <= 3'b0;
            valid_out <= 1'b0;
        end else if (valid_in) begin
            if (counter < 3) begin
                sum <= sum + data_in;
                counter <= counter + 1;
                valid_out <= 1'b0;
            end else begin
                sum <= sum + data_in;
                data_out <= sum + data_in; // Sum of four inputs
                valid_out <= 1'b1;
                counter <= 3'b0;
                sum <= 10'b0; // Reset sum for next accumulation
            end    
        end else begin
            valid_out <= 1'b0;
        end
    end
    
endmodule
