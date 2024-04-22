
module synchronizer(
    input wire clk_a,       // Clock signal A
    input wire clk_b,       // Clock signal B
    input wire arstn,       // Active-low reset signal for clock A
    input wire brstn,       // Active-low reset signal for clock B
    input wire [3:0] data_in,  // 4-bit input data
    input wire data_en,     // Input enable signal
    output reg [3:0] dataout  // 4-bit output data
);

    // Registers for holding data and enable signals across clock domains
    reg [3:0] data_reg;
    reg en_data_reg;
    reg en_clap_one, en_clap_two;

    // Synchronize and store the data_in with clk_a
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Synchronize the enable signal across to clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // Output assignment based on the synchronized enable signal
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_clap_two) begin
            dataout <= data_reg;
        end
    end

endmodule
