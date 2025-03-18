module carry_save_adder #(
    parameter int N = 32
) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    input  [N-1:0] c,
    output [N+1:0] s
);
    wire [N:0] inter[2];
    assign inter[1][0] = 0;
    genvar i;
    generate
        for (i = 0; i < N; i += 1) assign {inter[1][i+1], inter[0][i]} = a[i] + b[i] + c[i];
    endgenerate
    assign inter[0][N] = 0;

    wire csa_cout;
    carry_select_adder _csa (
        .a(inter[0][N-1:0]),
        .b(inter[1][N-1:0]),
        .cin(1'b0),
        .s(s[N-1:0]),
        .cout(csa_cout)
    );
    assign s[N+1:N] = csa_cout + inter[0][N] + inter[1][N];  // can be a half-adder (how?)

endmodule

module csaa_test;
    reg [31:0] a, b, c;
    wire [33:0] res;
    carry_save_adder _csaa (
        .a(a),
        .b(b),
        .c(c),
        .s(res)
    );
    int i;
    initial begin
        // $monitor(a, "+", b, "+", cin, "=", res);
        for (i = 0; i < 1000; i += 1) begin
            a = $urandom();
            b = $urandom();
            c = $urandom();
            #1;
            if (a + b + c !== res) $display(a, "+", b, "+", c, "!=", res, "!!!! FAILED !!!!");
            else $display(a, "+", b, "+", c, "=", res);
        end
        $finish();

    end
endmodule
