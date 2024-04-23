module synchronizer (
    input  logic clk_a,        // Clock A
    input  logic clk_b,        // Clock B
    input  logic arstn,        // Active-low asynchronous reset for clk_a
    input  logic brstn,        // Active-low asynchronous reset for clk_b
    input  logic [3:0] data_in, // 4-bit input data signal
    input  logic data_en,      // Enable signal
    output logic [3:0] dataout  // 4-bit output data signal
);

    // Registers for capturing input in clk_a domain
    logic [3:0] data_reg;
    logic en_data_reg;

    // Registers for enabling in clk_b domain
    logic en_clap_one;
    logic en_clap_two;

    // Data capturing on clk_a with asynchronous reset
    always_ff @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Propagating enable through two-stage synchronizer on clk_b with asynchronous reset
    always_ff @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // Assigning output based on synchronized enable
    always_ff @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_clap_two) begin
            dataout <= data_reg;
        end
    end

endmodule
