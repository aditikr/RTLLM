module edge_detect(
    input  logic clk,
    input  logic rst_n,
    input  logic a,
    output logic rise,
    output logic down
);

    // To capture the previous state of 'a'
    logic a_prev;

    // Register to store the previous state of 'a' across clock cycles
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
        end else begin
            a_prev <= a;
        end
    end

    // Rising edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
        end else begin
            rise <= (a == 1'b1 && a_prev == 1'b0);
        end
    end

    // Falling edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            down <= 1'b0;
        end else begin
            down <= (a == 1'b0 && a_prev == 1'b1);
        end
    end

endmodule
