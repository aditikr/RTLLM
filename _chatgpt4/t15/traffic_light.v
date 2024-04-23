module traffic_light(
    input wire clk,
    input wire rst_n,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    // State definitions
    parameter s1_red = 2'b00,
              s2_yellow = 2'b01,
              s3_green = 2'b10,
              idle = 2'b11;
    
    // Registers
    reg [1:0] state, next_state;
    reg [7:0] cnt;
    reg [7:0] next_cnt;
    
    // Initial state
    initial begin
        state = idle;
        cnt = 8'd75;  // Total sum of cycles for one complete red-yellow-green-red sequence
        red = 0;
        yellow = 0;
        green = 0;
    end

    // State update logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 8'd75;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
        end
    end

    // State transition logic
    always @(*) begin
        // Default values
        next_state = state;
        next_cnt = cnt - 1;
        
        case(state)
            idle: begin
                next_state = s1_red;
                next_cnt = 8'd10; // Start with red light
            end
            s1_red: begin
                if (cnt == 0) begin
                    next_state = s3_green;
                    next_cnt = 8'd60;  // Green state
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    next_state = s1_red;
                    next_cnt = 8'd10;  // Red state
                end
            end
            s3_green: begin
                if (cnt == 0 || (pass_request && cnt > 10)) begin
                    next_state = s2_yellow;
                    next_cnt = 8'd5;  // Yellow state
                end
                else if (pass_request && cnt <= 10) begin
                    next_state = s2_yellow;
                end
            end
        endcase
    end

    // Output logic for traffic lights
    always @(state) begin
        red = 0; yellow = 0; green = 0;

        case(state)
            s1_red: red = 1;
            s2_yellow: yellow = 1;
            s3_green: green = 1;
            idle: begin
                red = 0; yellow = 0; green = 0;
            end
        endcase
    end

    // Clock output
    always @(cnt or state) begin
        if (state == idle) begin
            clock = 8'd0; // No active count during idle
        end else begin
            clock = cnt;
        end
    end
    
endmodule
