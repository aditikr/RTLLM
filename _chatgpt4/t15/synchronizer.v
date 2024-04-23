module synchronizer(
    input        clk_a,      // Clock A
    input        clk_b,      // Clock B
    input        arstn,      // Asynchronous reset for Clock A (active low)
    input        brstn,      // Asynchronous reset for Clock B (active low)
    input [3:0]  data_in,    // 4-bit data input, synchronized to Clock A
    input        data_en,    // Enable signal, synchronized to Clock A
    output reg [3:0] dataout // 4-bit data output, synchronized to Clock B
);

    // Registers for input storage and synchronization across clock domains
    reg [3:0] data_reg;
    reg       en_data_reg;     // Register for enable signal in clk_a domain
    reg       en_clap_one;     // First flip-flop for enable signal in clk_b domain
    reg       en_clap_two;     // Second flip-flop for enable signal in clk_b domain

    // Synchronization of data_in and data_en to clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Synchronization and stabilization of en_data_reg across clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;       // Capture the enable from clk_a domain
            en_clap_two <= en_clap_one;       // Delay it by one more clock cycle
        end
    end
    
    // Output assignment based on enable synchronization
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            dataout <= 4'b0;
        else if (en_clap_two)
            dataout <= data_reg; // Update dataout with the synchronized input data
        // else dataout retains its previous value (implicit latch-like behavior)
    end

endmodule
