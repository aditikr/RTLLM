
module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [7:0] data_accumulator [0:3];
reg [2:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        valid_out <= 0;
        data_out <= 10'b0;
        counter <= 3'b0;
        data_accumulator <= 4'b0;
    end else begin
        if (valid_in) begin
            data_accumulator[counter] <= data_in;
            counter <= counter + 1;
            if (counter == 3) begin
                data_out <= data_accumulator[0] + data_accumulator[1] + data_accumulator[2] + data_accumulator[3];
                valid_out <= 1;
            end else begin
                valid_out <= 0;
            end
        end
    end
end

endmodule
