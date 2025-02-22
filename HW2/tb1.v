module tb1;
    reg [31:0] in1;
    reg clk;
    reg load;
    wire [31:0] out1;
    main _q1 (
        .in1 (in1),
        .load(load),
        .clk (clk),
        .out1(out1)
    );

    initial begin
        clk = 0;
        forever #1 clk = !clk;
    end

    reg [31:0] reference_res;
    int all_tests, success_count;
    initial begin
        repeat (200) begin
            #8 load = 1;
            in1 = $urandom();
            #2 load = 0;
            #8 reference_res = in1 ^ (in1 & (-in1));
            if (reference_res !== out1) $display("failed => in1 : %b", in1, " out1 : %b", out1);
            else success_count = success_count + 1;
            all_tests = all_tests + 1;
        end

        if (all_tests == success_count) $display("ACCEPTED");
        else $display("FAILED");
        $display(success_count, " /", all_tests);
        $finish(0);
    end
endmodule
