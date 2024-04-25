module synchronizer(
    input       clk_a,
    input       clk_b,
    input       arstn,
    input       brstn,
    input [3:0] data_in,
    input       data_en,
    output reg [3:0] dataout
);

    // Register declarations
    reg [3:0] data_reg;
    reg       en_data_reg;
    reg       en_clap_one;
    reg       en_clap_two;

    // Synchronize the data_in with clk_a
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Double flip-flop synchronizer for the enable signal on clk_b
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // Determine output data based on the stabilized enable signal
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            dataout <= 4'b0;
        else if (en_clap_two)
            dataout <= data_reg;
        // Note: When en_clap_two is not high, maintain the current state of output
    end

endmodule
