typedef enum bit [3:0] {
    ADD  = 0,
    SUB  = 1,
    MUL  = 2,
    DIV  = 3,
    AND  = 4,
    OR   = 5,
    XOR  = 6,
    CLO  = 7,
    CLZ  = 8,
    SLL  = 9,
    SRL  = 10,
    SRA  = 11,
    ROTR = 12
} aluop_t;

module tb;
    localparam int N = 32;
    reg [N-1:0] a;
    reg [N-1:0] b;
    aluop_t aluop;
    reg output_inverted;
    reg output_inc;
    reg clk;
    reg rst;
    wire [N-1:0] res_low;
    wire [N-1:0] res_high;
    wire done;


    main _main (
        .a(a),
        .b(b),
        .aluop(aluop),
        .output_inverted(output_inverted),
        .output_inc(output_inc),
        .clk(clk),
        .rst(rst),
        .res_low(res_low),
        .res_high(res_high),
        .done(done)
    );

    initial begin
        clk = 0;
        forever #1 clk = !clk;
    end

    int all_tests, success_count, i;
    reg [31:0] calc_low, calc_high;
    reg signed [31:0] signed_hack0;
    reg signed [63:0] signed_hack1;
    initial begin
        rst = 1;
        #2 rst = 0;
        repeat (500) begin
            a = $urandom();
            b = $urandom();
            output_inverted = $urandom();
            output_inc = $urandom();

            if (all_tests < 20) aluop = ADD;
            else if (all_tests < 40) aluop = SUB;
            else if (all_tests < 140) aluop = MUL;
            else if (all_tests < 240) aluop = DIV;
            else if (all_tests < 260) aluop = AND;
            else if (all_tests < 280) aluop = OR;
            else if (all_tests < 300) aluop = XOR;
            else if (all_tests < 360) aluop = CLO;
            else if (all_tests < 420) aluop = CLZ;
            else if (all_tests < 440) aluop = SLL;
            else if (all_tests < 460) aluop = SRL;
            else if (all_tests < 480) aluop = SRA;
            else if (all_tests < 500) aluop = ROTR;


            case (aluop)
                ADD: {calc_high, calc_low} = a + b;
                SUB: {calc_high, calc_low} = a - b;
                MUL: begin  // unsigned multiply
                    // when a multiply query first arrives
                    {calc_high, calc_low} = a * b;
                    // handle using shift-and-add algorithm
                    // optimize with carry_save_adder
                end
                DIV: begin  // unsigned divide
                    // when a divide query first arrives
                    calc_high = a % b;
                    calc_low  = a / b;
                    // handle using the algorithm from hw2q2
                end
                AND: begin
                    calc_high = 0;
                    calc_low  = a & b;
                end
                OR: begin
                    calc_high = 0;
                    calc_low  = a | b;
                end
                XOR: begin
                    calc_high = 0;
                    calc_low  = a ^ b;
                end
                CLO: begin  // count number of leading ones
                    calc_low  = 0;
                    calc_high = 0;
                    for (i = 0; i < N; i += 1) begin
                        if (a[i] == 1'b1) calc_low += 1;
                        else calc_low = 0;
                    end
                end
                CLZ: begin  // count number of leading zeroes
                    calc_low  = 0;
                    calc_high = 0;
                    for (i = 0; i < N; i += 1) begin
                        if (a[i] == 1'b0) calc_low += 1;
                        else calc_low = 0;
                    end
                end
                SLL: begin  // shift left logical
                    {calc_high, calc_low} = a << b[4:0];
                end
                SRL: begin  // shift right logical
                    calc_low  = a >> b[4:0];
                    calc_high = 0;
                end
                SRA: begin  // shift right arithmetic
                    signed_hack0 = a;
                    signed_hack1 = signed_hack0;
                    {calc_high, calc_low} = signed_hack1 >>> b[4:0];
                end
                ROTR: begin  // rotate right
                    {calc_low, calc_high} = {a, {N{1'b0}}} >> b[4:0];
                    calc_low = calc_low | calc_high;
                    calc_high = 0;
                end
                default begin
                    calc_low  = 0;
                    calc_high = 0;
                end
            endcase

            #400;
            if (output_inverted) begin
                if ((~{calc_high, calc_low}) + output_inc !== {res_high, res_low})
                    $display(
                        "Failed test#%d : a=0x%x b=0x%x",
                        all_tests,
                        a,
                        b,
                        " op:",
                        aluop,
                        "(~)+%b",
                        output_inc,
                        " result: 0x%x",
                        {
                            res_high, res_low
                        },
                        " != 0x%x",
                        {
                            (~{calc_high, calc_low}) + output_inc
                        }
                    );
                else success_count += 1;
            end else begin
                if ({calc_high, calc_low} + output_inc !== {res_high, res_low})
                    $display(
                        "Failed test#%d : a=0x%x b=0x%x",
                        all_tests,
                        a,
                        b,
                        " op:",
                        aluop,
                        "+%b   ",
                        output_inc,
                        " result: 0x%x",
                        {
                            res_high, res_low
                        },
                        " != 0x%x",
                        {
                            ({calc_high, calc_low}) + output_inc
                        }
                    );

                else success_count += 1;
            end
            all_tests += 1;
        end


        if (all_tests == success_count) $display("ACCEPTED");
        else $display("FAILED");
        $display(success_count, " /", all_tests);
        $finish(0);
    end
endmodule
