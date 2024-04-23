module synchronizer(
    input        clk_a,          // Clock signal A
    input        clk_b,          // Clock signal B
    input        arstn,          // Active-low reset for clk_a domain
    input        brstn,          // Active-low reset for clk_b domain
    input  [3:0] data_in,        // 4-bit data input
    input        data_en,        // Data enable/control signal
    output [3:0] dataout         // 4-bit synchronized data output
);
    reg [3:0] data_reg;          // Register to store data from clk_a domain
    reg       en_data_reg;       // Register to store enable signal from clk_a domain
    reg       en_clap_one;       // First flip-flop for enable signal in clk_b domain
    reg       en_clap_two;       // Second flip-flop for enable signal in clk_b domain

    // Register data_in and data_en on clk_a positive edge or arstn negative edge
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0000;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Register en_data_reg on clk_b positive edge or brstn negative edge through two stages
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // Output assignment based on en_clap_two
    // Blocking assignment is used in always block as indicated by your requirements
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0000;
        end else if (en_clap_two) begin
            dataout <= data_reg;  // Output updated data when en_clap_two is active
        end
    end
endmodule
