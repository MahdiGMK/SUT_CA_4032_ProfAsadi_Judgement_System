module tb0;
  reg  [3:0] a;
  reg  [3:0] b;
  reg        sub_notadd;
  reg  [4:0] testing_val;
  wire [3:0] s;
  wire       cout;
  main testing (
      .a(a),
      .b(b),
      .sub_notadd(sub_notadd),
      .s(s),
      .cout(cout)
  );

  reg verdict;
  int all_tests, success_count;
  initial begin
    verdict   = 1;
    all_tests = 200;
    for (int i = 0; i < all_tests; i = i + 1) begin
      a <= $urandom();
      b <= $urandom();
      sub_notadd <= $urandom();
      #1;
      testing_val <= sub_notadd ? a + ~{sub_notadd, b} + 1 : a + b;
      #1;
      if (testing_val != {cout, s}) begin
        if (sub_notadd)
          $display(a, " - ", b, " = %b", {cout, s}, "! but should have been %b", testing_val);
        else $display(a, " + ", b, " = %b", {cout, s}, "! but should have been %b", testing_val);
        verdict = 0;
      end else success_count = success_count + 1;
    end
    if (verdict) $display("ACCEPTED");
    else $display("FAILED");
    $display(success_count, " /", all_tests);
  end
endmodule


