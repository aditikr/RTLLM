module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [4:0] i; // Count up to 16
    reg [31:0] product;
    reg [15:0] temp_ain;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 0;
            yout <= 0;
            product <= 0;
            temp_ain <= 0;
            done <= 0;
        end else begin
            if (start) begin
                if (i == 0) begin
                    // Initialize the values at the start of multiplication
                    product <= 0;
                    temp_ain <= ain;
                    done <= 0;
                end

                if (i < 16) begin
                    // Shift and accumulate algorithm
                    if (temp_ain[i]) // if the i-th bit of ain  is set
                        product <= product + (bin << i); // Accumulate the product
                end

                i <= i + 1; // Increment i every cycle when start is high

                if (i == 16) begin
                    yout <= product;   // Set the output product
                    done <= 1;         // Set done high indicating completion
                end else if (i == 17) begin
                    i <= 0;            // Reset i to allow restart
                    done <= 0;         // Reset done
                end
            end else begin
                i <= 0; // If start is not asserted, reset i
            end
        end
    end
endmodule
