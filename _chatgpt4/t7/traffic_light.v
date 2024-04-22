module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    // State definitions
    parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

    // Registers
    reg [7:0] cnt;
    reg [1:0] state;
    reg p_red, p_yellow, p_green;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 8'd0;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            case (state)
                idle: begin
                    state <= s1_red;
                    cnt <= 8'd10; // Set initial count for red state
                end
                s1_red: begin
                    if (cnt == 0) begin
                        state <= s3_green;
                        cnt <= 8'd60; // Set count for green state
                    end
                end
                s2_yellow: begin
                    if (cnt == 0) begin
                        state <= s1_red;
                        cnt <= 8'd10; // Set count for red state
                    end
                end
                s3_green: begin
                    if (cnt == 0 || (pass_request && cnt > 8'd10)) begin
                        state <= s2_yellow;
                        cnt <= 8'd5; // Set count for yellow state
                    end
                end
            endcase
        end
    end

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'd10;
        end else if (cnt > 0) begin
            cnt <= cnt - 1;
        end
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            red <= (state == s1_red);
            yellow <= (state == s2_yellow);
            green <= (state == s3_green);
        end
    end

    // Assign the internal counter to the output clock
    assign clock = cnt;

endmodule
