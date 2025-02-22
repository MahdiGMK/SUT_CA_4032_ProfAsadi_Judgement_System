module tb2;
    reg  start;
    reg  clk;
    wire done;

    localparam int N = 32;

    reg  [N-1:0] divisor;
    reg  [N-1:0] dividend;

    wire [N-1:0] quotient;
    wire [N-1:0] remainder;

    main _main (
        .clk  (clk),
        .start(start),
        .done (done),

        .dividend (dividend),
        .divisor  (divisor),
        .quotient (quotient),
        .remainder(remainder)
    );

    initial begin
        clk = 0;
        forever #1 clk = !clk;
    end

    int all_tests, success_count;
    initial begin
        repeat (200) begin
            #8 start = 1;
            dividend = $urandom();
            divisor  = $urandom() % (1 << 16) + 1;
            #2 start = 0;
            #400;
            if (remainder !== (dividend % divisor) || quotient !== (dividend / divisor)) begin
                $display("wrong calculation : ", dividend, " / ", divisor, " !=> ", quotient, ",",
                         remainder);
            end else success_count = success_count + 1;
            all_tests = all_tests + 1;
        end
        if (all_tests == success_count) $display("ACCEPTED");
        else $display("FAILED");
        $display(success_count, " /", all_tests);
        $finish(0);
    end

endmodule
