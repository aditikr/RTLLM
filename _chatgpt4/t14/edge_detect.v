module edge_detect (
    input wire clk,           // Clock signal
    input wire rst_n,         // Active low reset signal
    input wire a,             // Input signal whose edges are to be detected
    output reg rise,          // Output signal for rising edge detection
    output reg down           // Output signal for falling edge detection
);

    reg a_prev;   // Register to hold the previous state of the input signal

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronously reset output and state registers when reset is low
            rise <= 1'b0;
            down <= 1'b0;
            a_prev <= 1'b0;
        end else begin
            // On clock edge, update the previous state register
            a_prev <= a;

            // Detect rising edge
            if (a == 1'b1 && a_prev == 1'b0) begin
                rise <= 1'b1;
            end else begin
                rise <= 1'b0;
            end

            // Detect falling edge
            if (a == 1'b0 && a_prev == 1'b1) begin
                down <= 1'b1;
            end else begin
                down <= 1'b0;
            end
        end
    end

endmodule
