module synchronizer(
    input        clk_a,      // Clock A
    input        clk_b,      // Clock B
    input        arstn,      // Active low asynchronous reset signal for Clock A
    input        brstn,      // Active low asynchronous reset signal for Clock B
    input [3:0]  data_in,    // 4-bit input data
    input        data_en,    // Enable signal
    output reg [3:0] dataout // 4-bit output data
);

    reg [3:0] data_reg;       // Data register for storing input data
    reg en_data_reg;          // Register for storing enable signal
    reg en_clap_one, en_clap_two; // Register for delaying enable signal over clk_b

    // Synchronize data to clk_a
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0000;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Delay enable signal by two clk_b cycles
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // Data output logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 0;
        end else if (en_clap_two) begin
            dataout <= data_reg;  // Output the data if enabled
        end
    end

endmodule
