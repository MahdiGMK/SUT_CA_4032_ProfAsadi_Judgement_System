module memtb;
    parameter int LGSIZE = 9;
    reg Wen, Jen, clk;
    reg [LGSIZE-1:0] Addr;
    reg [31:0] Din;
    reg [31:0] Jin;
    wire [31:0] Jout;
    wire [31:0] Dout;

    main _main (
        .clk (clk),
        .Addr(Addr),
        .Wen (Wen),
        .Din (Din),
        .Dout(Dout),
        .Jen (Jen),
        .Jin (Jin),
        .Jout(Jout)
    );

    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    parameter int SIZE = 1 << LGSIZE;
    reg [31:0] data_in[SIZE];
    reg [31:0] data_out[SIZE];
    int i;
    initial begin
        Jen  = 0;
        Jin  = 0;
        Addr = 0;
        Wen  = 0;
        Din  = 0;
        #10;

        for (i = 0; i < SIZE; i += 1) data_in[i] = $urandom();
        Jen = 1;
        for (i = 0; i < SIZE; i += 1) begin
            Jin = data_in[SIZE-i-1];
            #2;
        end
        Jen = 0;
        for (i = 0; i < SIZE; i += 1) begin
            Addr = i;
            #2;
            if (data_in[i] !== Dout) begin
                $display("failed");
                $display("[%x] == %x should've been %x", i[8:0], Dout, data_in[i]);
            end
            data_in[i] = $urandom();
            Din = data_in[i];
            Wen = 1;
            #2;
            Wen = 0;
            if (data_in[i] !== Dout) begin
                $display("failed");
                $display("[%x] == %x should've been %x", i[8:0], Dout, data_in[i]);
            end
            data_in[i] = $urandom();
            Din = data_in[i];
            Wen = 1;
            #2;
            Wen = 0;
        end
        Jen = 1;
        for (i = 0; i < SIZE; i++) begin
            data_out[SIZE-i-1] = Jout;
            #2;
        end
        for (i = 0; i < SIZE; i++) begin
            if (data_in[i] !== data_out[i]) begin
                $display("failed");
                $display("[%x] == %x should've been %x", i[8:0], data_out[i], data_in[i]);
            end
            data_in[i] = $urandom();
        end
        $finish(0);
    end
endmodule
