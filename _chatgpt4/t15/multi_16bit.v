module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

// Internal Signals
reg [4:0] i;
reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg start_prev; // To detect rising edge of start

// FSM States
typedef enum reg [1:0] {
    IDLE,
    LOAD,
    COMPUTE,
    COMPLETE
} state_t;

state_t state, next_state;

// Update the state of the FSM
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic and output logic
always @(*) begin
    // Default assignments
    next_state = state;
    done = 1'b0;
    
    case (state)
        IDLE: begin
            if (start && !start_prev) next_state = LOAD;
        end
        LOAD: begin
            next_state = COMPUTE;
        end
        COMPUTE: begin
            if (i < 16) begin
                next_state = COMPUTE;
            end else begin
                next_state = COMPLETE;
            end
        end
        COMPLETE: begin
            done = 1'b1;
            if (!start) next_state = IDLE;
        end
    endcase
end

// Combinational logic for shift and accumulate
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 5'b0;
        yout_r <= 32'b0;
        areg <= 16'b0;
        breg <= 16'b0;
        start_prev <= 1'b0;
    end else begin
        start_prev <= start;
        case (state)
            LOAD: begin
                areg <= ain;
                breg <= bin;
                yout_r <= 32'b0;
                i <= 5'b0;
            end
            COMPUTE: begin
                if (areg[i]) begin
                    yout_r <= yout_r + (breg << i);
                end
                i <= i + 1;
            end
            COMPLETE: begin
                yout <= yout_r;
            end
        endcase
    end
end

endmodule 
