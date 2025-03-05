module main (
    input [31:0] in1,
    input load,
    input clk,
    output reg [31:0] out1
);
    reg [31:0] r1;
    reg [31:0] r2;
    reg [ 2:0] state;
    always @(posedge clk) begin
        if (load) begin
            r1 <= in1;
            state <= 0;
        end else begin
            case (state)
                0: r2 <= -r1;
                1: r2 <= r1 & r2;
                2: r2 <= -r2;
                3: begin
                    out1 <= r1 + r2;
                    r2   <= r1 + r2;
                end
                default: ;
            endcase
            state <= state + 1;
        end
    end

endmodule
