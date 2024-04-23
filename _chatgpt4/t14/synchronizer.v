module synchronizer(
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);
    
    // Data and enable signal registers on clk_a
    reg [3:0] data_reg;
    reg en_data_reg;
    
    // Two stage synchronizer registers for the enable signal on clk_b
    reg en_clap_one;
    reg en_clap_two;

    // Capture input data and enable signal on clk_a domain
    always @(posedge clk_a, negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Two-stage synchronizer for enable signal on clk_b domain
    always @(posedge clk_b, negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // Output assignment logic in clk_b domain
    always @(posedge clk_b, negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_clap_two) begin
            dataout <= data_reg;
        end
    end

endmodule
