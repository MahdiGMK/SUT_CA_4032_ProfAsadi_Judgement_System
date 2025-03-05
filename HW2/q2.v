// division algorithm
module main #(
    localparam int N = 32
) (
    input [N-1:0] divisor,
    input [N-1:0] dividend,
    input start,
    input clk,
    output reg [N-1:0] quotient,
    output reg [N-1:0] remainder,
    output reg done
);
    reg [2*N-1:0] a, q, b, counter;
    always @(posedge clk) begin
        if (start) begin
            a       <= 0;
            q       <= dividend;
            b       <= divisor;
            counter <= 2 * N;
            done    <= 0;
        end else if (|counter) begin
            {a, q} = {a, q} << 1;
            if (a >= b) begin
                a = a - b;
                q[0] = 1;
            end
            counter <= counter - 1;
        end else begin
            remainder <= a;
            quotient <= q;
            done <= 1;
        end
    end
endmodule
