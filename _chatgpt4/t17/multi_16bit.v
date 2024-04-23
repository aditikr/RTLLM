module multi_16bit(
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);
    // Internal signal definitions
    reg [31:0] product;
    reg [4:0] counter;  // 5-bit counter to handle up to 16-bit positions

    // Multiplication process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all internal states
            product <= 0;
            counter <= 0;
            yout <= 0;
            done <= 0;
        end else begin
            if (start) begin
                if (counter == 0) begin
                    // Initially load data into the internal registers
                    product <= 0;
                    counter <= 1;
                    done <= 0;
                end else if (counter > 0 && counter <= 16) begin
                    // Shift and accumulate phase
                    if (bin[counter - 1]) begin
                        product <= product + (ain << (counter - 1));
                    end
                    counter <= counter + 1;
                end
                if (counter == 17) begin
                    // Finalize multiplication
                    yout <= product;
                    done <= 1;
                    counter <= 0;  // Reset counter to enable a new multiplication
                end
            end else begin
                // Ensure done and counter are reset when start is not active
                if (done == 1) begin
                    done <= 0;
                end
                if (counter != 0) begin
                    counter <= 0;
                end
            end
        end
    end
endmodule
