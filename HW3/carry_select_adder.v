module carry_select_adder #(
    parameter int N = 32
) (
    input [N-1:0] a,
    input [N-1:0] b,
    input cin,
    output [N-1:0] s,
    output cout
);
    // 4-segment CSA
    localparam int SN = N / 4;
    wire [SN:0] c0segment[4];
    wire [SN:0] c1segment[4];
    wire segm_carry[5];
    assign segm_carry[0] = cin;
    genvar i;
    generate
        for (i = 0; i < 4; i += 1) begin : g_segments
            localparam int RR = SN * i;
            localparam int LL = RR + SN - 1;
            assign c0segment[i] = a[LL:RR] + b[LL:RR];
            assign c1segment[i] = a[LL:RR] + b[LL:RR] + 1;
            assign {segm_carry[i+1], s[LL:RR]} = segm_carry[i] ? c1segment[i] : c0segment[i];
        end
    endgenerate
    assign cout = segm_carry[4];

endmodule

module csa_test;
    reg [31:0] a, b;
    reg cin;
    wire [32:0] res;
    carry_select_adder _csa (
        .a(a),
        .b(b),
        .cin(cin),
        .cout(res[32]),
        .s(res[31:0])
    );
    int i;
    initial begin
        // $monitor(a, "+", b, "+", cin, "=", res);
        for (i = 0; i < 1000; i += 1) begin
            a   = $urandom();
            b   = $urandom();
            cin = $urandom();
            #1;
            if (a + b + cin !== res) $display(a, "+", b, "+", cin, "!=", res, "!!!! FAILED !!!!");
            else $display(a, "+", b, "+", cin, "=", res);
        end
        $finish();

    end
endmodule
