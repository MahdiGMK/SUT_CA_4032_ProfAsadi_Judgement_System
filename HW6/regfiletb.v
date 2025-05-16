module regfiletb;
    reg clk, rst;
    reg [4:0] Awrite, Aread0, Aread1;
    reg [31:0] Dwrite;
    wire [31:0] Dread0, Dread1;

    main _regfile (
        .clk(clk),
        .rst(rst),
        .Awrite(Awrite),
        .Aread0(Aread0),
        .Aread1(Aread1),
        .Dwrite(Dwrite),
        .Dread0(Dread0),
        .Dread1(Dread1)
    );

    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    reg [31:0] status[32];
    int i;
    initial begin
        status[0] = 0;
        Aread0 = 0;
        Aread1 = 0;
        #2;
        assert (Dread0 === 0);
        assert (Dread1 === 0);
        rst = 1;
        #2 rst = 0;
        Awrite = 0;
        // does rst work?
        for (i = 0; i < 32; i++) begin
            status[i] = 0;
            Aread0 = i;
            Aread1 = 31 - i;
            #2;
            assert (Dread0 == 0);
            assert (Dread1 == 0);
        end

        for (i = 0; i < 1000; i++) begin
            Awrite = $urandom();
            Dwrite = $urandom();
            Aread0 = $urandom();
            Aread1 = $urandom();
            if (Awrite !== 0) status[Awrite] = Dwrite;
            #2;
            assert (Dread0 == status[Aread0]);
            assert (Dread1 == status[Aread1]);
        end

        rst = 1;
        #2 rst = 0;
        Awrite = 0;
        for (i = 0; i < 32; i++) begin
            status[i] = 0;
            Aread0 = i;
            Aread1 = 31 - i;
            #2;
            assert (Dread0 == 0);
            assert (Dread1 == 0);
        end

        for (i = 0; i < 1000; i++) begin
            Awrite = $urandom();
            Dwrite = $urandom();
            Aread0 = $urandom();
            Aread1 = $urandom();
            if (Awrite !== 0) status[Awrite] = Dwrite;
            #2;
            assert (Dread0 == status[Aread0]);
            assert (Dread1 == status[Aread1]);
        end
        $finish(0);
    end
endmodule
