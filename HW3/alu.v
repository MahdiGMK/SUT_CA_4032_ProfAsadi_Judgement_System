// add/sub/div/divu/mul/mulu
// clo (leading ones)
// clz (leading zeros)
// low2high
// low2low
// hight2low
//
// typedef enum bit [3:0] {
//     ADD  = 0,
//     SUB  = 1,
//     MUL  = 2,
//     DIV  = 3,
//     AND  = 4,
//     OR   = 5,
//     XOR  = 6,
//     CLO  = 7,
//     CLZ  = 8,
//     SLL  = 9,
//     SRL  = 10,
//     SRA  = 11,
//     ROTR = 12
// } aluop_t;
module main #(
    parameter int N = 32
) (
    input [N-1:0] a,
    input [N-1:0] b,
    input aluop_t aluop,
    input output_inverted,
    input output_inc,
    input clk,
    input rst,
    output [N-1:0] res_low,
    output [N-1:0] res_high,
    output reg done
);
    reg [N-1:0] calc_low;
    reg [N-1:0] calc_high;
    int i;
    assign {res_high, res_low} =  (
        (output_inverted ? ~{calc_high, calc_low} : {calc_high, calc_low}) + output_inc
        );
    always @(*) begin
        case (aluop)
            ADD: begin
                {calc_high, calc_low} = a + b;
                done = 1;
            end
            SUB: begin
                {calc_high, calc_low} = a - b;
                done = 1;
            end
            MUL: begin  // unsigned multiply
                done = 0;  // zero the done signal
                // when a multiply query first arrives
                {calc_high, calc_low} = a * b;
                // handle using shift-and-add algorithm
                // optimize with carry_save_adder
                done = 1;  // handle after operation is done
            end
            DIV: begin  // unsigned divide
                done = 0;  // zero the done signal
                // when a divide query first arrives
                calc_high = a % b;
                calc_low = a / b;
                // handle using the algorithm from hw2q2
                done = 1;  // handle after operation is done
            end
            AND: begin
                calc_high = 0;
                calc_low = a & b;
                done = 1;
            end
            OR: begin
                calc_high = 0;
                calc_low = a | b;
                done = 1;
            end
            XOR: begin
                calc_high = 0;
                calc_low = a ^ b;
                done = 1;
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
                done = 1;
            end
            SRL: begin  // shift right logical
                calc_low = a >> b[4:0];
                calc_high = 0;
                done = 1;
            end
            SRA: begin  // shift right arithmetic
                {calc_high, calc_low} = signed'(a) >>> b[4:0];
                done = 1;
            end
            ROTR: begin  // rotate right
                {calc_low, calc_high} = {a, {N{1'b0}}} >> b[4:0];
                calc_low = calc_low | calc_high;
                calc_high = 0;
                done = 1;
            end
            default begin
                calc_low = 0;
                calc_high = 0;
                done = 1;
            end
        endcase
    end
endmodule
