module fast_mult #(
    parameter int N = 32
) (
    input [N-1:0] a,
    input [N-1:0] b,
    input is_signed,
    input start,
    output reg [2*N-1:0] res,
    output reg done
);
    reg  [2*N-1:0] tmp;

    reg  [  N-1:0] csaa_a;
    reg  [  N-1:0] csaa_b;
    reg  [  N-1:0] csaa_c;
    wire [  N+1:0] csaa_s;

    carry_save_adder _csaa (
        .a(csaa_a),
        .b(csaa_b),
        .c(csaa_c),
        .s(csaa_s)
    );
endmodule
