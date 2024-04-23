module synchronizer(
    input  wire         clk_a,    // Clock input A
    input  wire         clk_b,    // Clock input B
    input  wire         arstn,    // Asynchronous reset for clock A
    input  wire         brstn,    // Asynchronous reset for clock B
    input  wire [3:0]   data_in,  // 4-bit input data
    input  wire         data_en,  // Data enable signal
    output reg  [3:0]   dataout   // 4-bit output data
);

    // Registers for data and enable signal on clock domain A
    reg [3:0] data_reg;
    reg en_data_reg;

    // Registers for the enable signal on clock domain B
    reg en_clk_b_one;
    reg en_clk_b_two;

    // Synchronization of data and enable signals into clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Synchronization of the enable signal into clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clk_b_one <= 1'b0;
            en_clk_b_two <= 1'b0;
        end else begin
            en_clk_b_one <= en_data_reg;
            en_clk_b_two <= en_clk_b_one;
        end
    end

    // Output assignment and control in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_clk_b_two) begin
            dataout <= data_reg;
        end else begin
            dataout <= dataout;
        end
    end

endmodule
