module adder_pipe_64bit(
    input         clk,
    input         rst_n,
    input         i_en,
    input  [63:0] adda,
    input  [63:0] addb,
    output [64:0] result,
    output        o_en
);

    // Register definitions for pipeline stages
    reg [63:0] adda_reg1, adda_reg2;
    reg [63:0] addb_reg1, addb_reg2;
    reg        i_en_reg1, i_en_reg2;
    reg [64:0] result_reg1, result_reg2;
    
    // Sum computation (temporary signal to hold sum of A and B)
    wire [64:0] temp_sum;
    
    // Stage 1: Register inputs and compute first partial results
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg1 <= 64'b0;
            addb_reg1 <= 64'b0;
            i_en_reg1 <= 1'b0;
        end
        else if (i_en) begin
            adda_reg1 <= adda;
            addb_reg1 <= addb;
            i_en_reg1 <= i_en;
        end
    end

    // Combinational sum for first stage
    assign temp_sum = adda_reg1 + addb_reg1;

    // Stage 2: Register the sums along with the enable signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_reg1 <= 65'b0;
            i_en_reg2   <= 1'b0;
        end else begin
            result_reg1 <= temp_sum;
            i_en_reg2   <= i_en_reg1;
        end
    end

    // Connect to the output with registered results
    assign result = result_reg1;
    assign o_en = i_en_reg2;

endmodule
