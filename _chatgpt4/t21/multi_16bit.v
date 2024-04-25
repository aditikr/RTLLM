module multi_16bit(
    input        clk,
    input        rst_n,
    input        start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg       done
);

    reg [15:0]  a_reg, b_reg;
    reg [4:0]   i; // 16-bit wide requires 16-cycle loop + 1 extra for final flag, using 5-bit index
    reg [31:0]  p_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 16'b0;
            b_reg <= 16'b0;
            p_reg <= 32'b0;
            i <= 5'b0;
            done <= 1'b0;
            yout <= 32'b0;
        end else begin
            if (start) begin
                if (i == 0) begin
                    a_reg <= ain;
                    b_reg <= bin;
                    p_reg <= 32'b0;
                    done <= 1'b0;
                end else if (i <= 16) begin
                    if (a_reg[0]) // Check LSB of a_reg
                        p_reg <= p_reg + (b_reg << (i - 1)); // Shift and accumulate
                    a_reg <= a_reg >> 1; // Shift a_reg right for next bit
                end 
                
                if (i == 16) begin
                    done <= 1'b1; // Set done when multiplication is complete
                    yout <= p_reg; // Assign the product to output
                end else begin
                    done <= 1'b0;
                end
                
                i <= i + 1; // Increment counter
            end else begin
                i <= 0; // Reset i if not started
                done <= 0; // Reset done flag
            end
        end
    end
endmodule
