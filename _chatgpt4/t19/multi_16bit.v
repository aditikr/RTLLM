module multi_16bit(
    input        clk,
    input        rst_n,
    input        start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output       done
);

    // Internal registers
    reg [15:0] areg, breg;
    reg [31:0] yout_r;
    reg [4:0]  i; // To count up to 16
    reg        done_r;

    //Assign output to internal registers
    assign yout = yout_r;
    assign done = done_r;

    // Control logic for i and done_r
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 0;
            done_r <= 0;
        end else if (start) begin
            if (i < 16) begin
                i <= i + 1;
                done_r <= 0;
            end else begin
                i <= 0;
                done_r <= 1;
            end
        end else begin
            i <= 0;
            done_r <= 0;
        end
    end

    // Logic for multiplication using shift and accumulate
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 0;
            breg <= 0;
            yout_r <= 0;
        end else if (start) begin
            if (i == 0) begin
                areg <= ain;
                breg <= bin;
                yout_r <= 0;
            end else if (i <= 16) begin
                if (areg[0])
                    yout_r <= yout_r + (breg << (i - 1));
                areg <= areg >> 1;
            end
        end
    end

endmodule
