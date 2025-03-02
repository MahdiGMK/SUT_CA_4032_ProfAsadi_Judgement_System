// add/sub/div/divu/mul/mulu
// clo (leading ones)
// clz (leading zeros)
// low2high
// low2low
// hight2low
//
typedef enum {
    ADD  = 0,
    SUB  = 1,
    MUL  = 2,
    DIV  = 3,
    AND  = 4,
    OR   = 5,
    CLO  = 6,
    CLZ  = 7,
    SLL  = 8,
    SRL  = 9,
    SRA  = 10,
    ROTR = 11,
    SLT  = 12,
    SEQ  = 13
} aluop_t;
module alu #(
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
    output done
);
    reg [N-1:0] calc_low;
    reg [N-1:0] calc_high;
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
            MUL: begin
                done = 0;  // zero the done signal
                // when a multiply query first arrives
                {calc_high, calc_low} = a * b;
                // handle using shift-and-add algorithm
                // optimize with carry_save_adder
                done = 1;  // handle after operation is done
            end
            DIV: begin
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
            CLO: begin  // count number of leading ones

            end
            CLZ:  ;
            SLL:  ;
            SRL:  ;
            SRA:  ;
            ROTR: ;
            SLT:  ;
            SEQ:  ;
        endcase
    end
endmodule
