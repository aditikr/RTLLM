module multi_16bit(
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    reg [4:0] i; // 5-bit counter to handle up to 16 bits
    reg [31:0] yout_r; // 32-bit register to store the product
    reg done_r; // Register to indicate completion
    reg [15:0] areg, breg; // Registers to store ain and bin during operation

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 0;
            yout_r <= 0;
            done_r <= 0;
            areg <= 0;
            breg <= 0;
        end else if (start) begin
            if (i == 0) begin
                areg <= ain;
                breg <= bin;
                yout_r <= 0;
                done_r <= 0;
            end
            if (i < 16) begin
                i <= i + 1;
                // Shift and accumulate operation
                if (areg[i-1])
                    yout_r <= yout_r + (breg << (i-1));
            end else begin
                done_r <= 1;
                i <= 17; // Set i to 17 to indicate completion
            end
        end else begin
            i <= 0;
            done_r <= 0;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule
