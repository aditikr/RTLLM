
module traffic_light (
    input rst_n, // Reset signal (active low)
    input clk,   // Clock signal
    input pass_request, // Request signal for allowing vehicles to pass
    output reg [7:0] clock, // 8-bit output representing the count value of the internal counter
    output reg red, yellow, green // Output signals representing the state of the traffic lights
);

// Enumeration values for different states
parameter idle = 2'b00;
parameter s1_red = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green = 2'b11;

// Registers
reg [7:0] cnt;
reg [1:0] state, next_state;
reg p_red, p_yellow, p_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

always @* begin
    next_state = state;
    case (state)
        idle: begin
            next_state = s1_red;
        end
        s1_red: begin
            if (cnt == 3) begin
                next_state = s3_green;
            end
        end
        s2_yellow: begin
            if (cnt == 3) begin
                next_state = s1_red;
            end
        end
        s3_green: begin
            if (cnt == 3) begin
                next_state = s2_yellow;
            end
        end
    endcase
end

// Counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (pass_request && green) begin
            cnt <= 10;
        end else if (!green && p_green) begin
            cnt <= 60;
        end else if (!yellow && p_yellow) begin
            cnt <= 5;
        end else if (!red && p_red) begin
            cnt <= 10;
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Output assignment
assign clock = cnt;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
        case (state)
            idle: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
            s1_red: begin
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            s2_yellow: begin
                red <= 0;
                yellow <= 1;
                green <= 0;
            end
            s3_green: begin
                red <= 0;
                yellow <= 0;
                green <= 1;
            end
        endcase
    end
end

endmodule
