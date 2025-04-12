module tb;
    reg clk, rst, Jen;
    reg [31:0] instructions[512];
    reg [31:0] data_mem[512];

    reg [31:0] Jin;
    wire [31:0] Jout;
    wire [31:0] R[32];
    assign R[0] = 0;

    reg [31:0] inst_reg;
    reg [4:0] inst_rs, inst_rt, inst_rd;
    reg [31:0] val_rs, val_rt;
    reg [15:0] inst_imm;
    reg [8:0] ipc;
    reg [31:0] ireg[32];
    task write2reg(input [4:0] reg_dest, input [31:0] val);
        begin
            if (reg_dest !== 0) ireg[reg_dest] = val;
        end
    endtask
    function [31:0] sra(input [31:0] a, input [4:0] b);
        begin
            sra = ({{32{a[31]}}, a} >> b);
        end
    endfunction
    task exec_internal;
        begin
            inst_reg = instructions[ipc];
            ipc += 1;

            inst_rs  = inst_reg[25:21];
            inst_rt  = inst_reg[20:16];
            inst_rd  = inst_reg[15:11];
            inst_imm = inst_reg[15:0];
            val_rs   = ireg[inst_rs];
            val_rt   = ireg[inst_rt];
            case (inst_reg[31:26])
                6'b000000: begin  // RType
                    case (inst_reg[5:0])
                        6'b100000: write2reg(inst_rd, val_rs + val_rt);  // add
                        6'b100010: write2reg(inst_rd, val_rs - val_rt);  // sub
                        6'b100100: write2reg(inst_rd, val_rs & val_rt);  // and
                        6'b100101: write2reg(inst_rd, val_rs | val_rt);  // or
                        6'b100110: write2reg(inst_rd, val_rs ^ val_rt);  // xor
                        6'b000100: write2reg(inst_rd, val_rs << val_rt[4:0]);  // sll
                        6'b000110: write2reg(inst_rd, val_rs >> val_rt[4:0]);  // srl
                        6'b000111: write2reg(inst_rd, sra(val_rs, val_rt[4:0]));  // sra
                        default;
                    endcase
                end
                6'b001000: write2reg(inst_rt, val_rs + {{16{inst_imm[15]}}, inst_imm});  // addi
                default;
            endcase
            // c inst_reg[31:26]
        end
    endtask

    // main _main (
    //     .clk (clk),
    //     .rst (rst),
    //     .Jen (Jen),
    //     .Jin (Jin),
    //     .Jout(Jout),
    //     .R1  (R[1]),
    //     .R2  (R[2]),
    //     .R3  (R[3]),
    //     .R4  (R[4]),
    //     .R5  (R[5]),
    //     .R6  (R[6]),
    //     .R7  (R[7]),
    //     .R8  (R[8]),
    //     .R9  (R[9]),
    //     .R10 (R[10]),
    //     .R11 (R[11]),
    //     .R12 (R[12]),
    //     .R13 (R[13]),
    //     .R14 (R[14]),
    //     .R15 (R[15]),
    //     .R16 (R[16]),
    //     .R17 (R[17]),
    //     .R18 (R[18]),
    //     .R19 (R[19]),
    //     .R20 (R[20]),
    //     .R21 (R[21]),
    //     .R22 (R[22]),
    //     .R23 (R[23]),
    //     .R24 (R[24]),
    //     .R25 (R[25]),
    //     .R26 (R[26]),
    //     .R27 (R[27]),
    //     .R28 (R[28]),
    //     .R29 (R[29]),
    //     .R30 (R[30]),
    //     .R31 (R[31])
    // );

    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    int i;
    int nsteps;
    initial begin
        for (i = 0; i < 512; i++) {instructions[i], data_mem[i]} = 0;
        for (i = 0; i < 32; i++) ireg[i] = 0;
        ipc = 0;
        //   R TYPE       opcode(6)rt(5)rs(5)rd(5)shmt(5)func(6)
        //   I TYPE           opcode(6)rt(5)rs(5)imm(16)
        //   J TYPE           opcode(6)addr(26)
        instructions[0] = 32'b00000000100010000001000000100000;  // add (R)
        instructions[1] = 32'b00100000100000101111111111111111;  // addi(I)
        instructions[2] = 32'b00000000100010000001000000100010;  // sub (R)
        instructions[3] = 32'b00000000100010000001000000100100;  // and (R)
        instructions[4] = 32'b00000000100010000001000000100101;  // or  (R)
        instructions[5] = 32'b00000000100010000001000000100110;  // xor (R)
        instructions[6] = 32'b00000001000001000001000000000100;  // sll (R)
        instructions[7] = 32'b00000001000001000001000000000110;  // srl (R)
        instructions[8] = 32'b00000001000001000001000000000111;  // sra (R)

        instructions[0] = 32'b00100000000000100000000000000001;
        instructions[1] = 32'b00100000000001000000000000000100;
        instructions[2] = 32'b00100000000010000000000000010000;
        instructions[3] = 32'b00000000100010000001000000100000;
        instructions[4] = 32'b00100000100000101111111111111111;
        instructions[5] = 32'b00000000100010000001000000100010;
        instructions[6] = 32'b00000000100010000001000000100100;
        instructions[7] = 32'b00000000100010000001000000100101;
        instructions[8] = 32'b00000000100010000001000000100110;
        instructions[9] = 32'b00000001000001000001000000000100;
        instructions[10] = 32'b00000001000001000001000000000110;
        instructions[11] = 32'b00000001000001000001000000000111;

        rst = 1;
        #8 rst = 0;
        Jen = 1;
        for (i = 0; i < 512; i++) begin  // D mem
            Jin = data_mem[511-i];
            #2;
        end
        for (i = 0; i < 512; i++) begin
            Jin = instructions[511-i];
            #2;
        end
        Jen = 0;
        rst = 1;
        #2 rst = 0;  // cpu-ex

        $monitor("2: " , ireg[2], " | 4: ", ireg[4], " | 8: " , ireg[8]);
        nsteps = 12;
        for(i = 0; i < nsteps; i++) begin
            exec_internal();
            #2;
        end



        $finish(0);
    end
endmodule
