module pulse_detect(
    input        clk,
    input        rst_n,
    input        data_in,
    output logic data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        S0   = 2'b01,
        S01  = 2'b10
    } state_t;

    // State register
    state_t state = IDLE, next_state;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        case (state)
            IDLE: next_state = (data_in == 1'b0) ? S0 : IDLE;
            S0  : next_state = (data_in == 1'b1) ? S01 : S0;
            S01 : next_state = (data_in == 1'b0) ? S0 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always_comb begin
        data_out = (state == S01 && data_in == 1'b0) ? 1'b1 : 1'b0;
    end

endmodule
module synchronizer(
    input        clk_a, 
    input        clk_b,
    input        arstn, 
    input        brstn,
    input  [3:0] data_in, 
    input        data_en,
    output reg [3:0] dataout
);

    // Internal registers for data capturing and synchronization
    reg [3:0] data_reg;
    reg       en_data_reg, en_clap_one, en_clap_two;

    // Data Register Update (with clk_a)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg    <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Data_en Transition through clk_b
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // Dataout Assignment
    always @(posedge clk_b) begin
        if (en_clap_two)
            dataout <= data_reg;
    end

endmodule
