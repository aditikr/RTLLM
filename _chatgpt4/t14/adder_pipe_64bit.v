module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stages for inputs, carry, and output enable signal
reg [63:0] adda_reg1, adda_reg2;
reg [63:0] addb_reg1, addb_reg2;
reg i_en_reg1, i_en_reg2;

// Partial sum stored in stage registers
reg [64:0] partial_sum_reg;

// Initialization of pipeline registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg1 <= 0;
        addb_reg1 <= 0;
        i_en_reg1 <= 0;
        
        adda_reg2 <= 0;
        addb_reg2 <= 0;
        i_en_reg2 <= 0;
        
        partial_sum_reg <= 0;
        
        result <= 0;
        o_en <= 0;
    end else begin
        // Stage 1 - Capture inputs and enable signal
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        i_en_reg1 <= i_en;
        
        // Stage 2 - Perform addition
        adda_reg2 <= adda_reg1;
        addb_reg2 <= addb_reg1;
        i_en_reg2 <= i_en_reg1;
        partial_sum_reg <= {1'b0, adda_reg1} + {1'b0, addb_reg1};
        
        // Stage Output - Drive output results
        if (i_en_reg2) begin
            result <= partial_sum_reg;
            o_en <= 1;
        end else begin
            o_en <= 0;
        end
    end
end

endmodule
