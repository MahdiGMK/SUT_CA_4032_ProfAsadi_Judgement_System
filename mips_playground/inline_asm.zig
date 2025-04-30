pub fn main() !void {
    fnc();
}

// \\ add $0, $0, $0
// \\ add $0, $0, $31
// \\ add $0, $31, $31
// \\ add $31, $31, $31
// \\ sub $0, $0, $0
// \\ sub $31, $31, $31
// \\ or $0, $0, $0
// \\ or $31, $31, $31
// \\ and $0, $0, $0
// \\ and $31, $31, $31
// \\ xor $0, $0, $0
// \\ xor $31, $31, $31
// \\ slt $0, $0, $0
// \\ slt $31, $31, $31
// \\ sll $0, $0, $0
// \\ sll $31, $31, $31
// \\ srl $0, $0, $0
// \\ srl $31, $31, $31
// \\ sra $0, $0, $0
// \\ sra $31, $31, $31
// \\ rotrv $0, $0, $0
// \\ rotrv $31, $31, $31
// \\
// \\ addi $0, $0, 0
// \\ addi $0, $0, 0xffff
// \\ addi $31, $31, 0
// \\ addi $31, $31, 0xffff
// // \\ sub $0, $0, 0
// // \\ sub $0, $0, 0xffff
// // \\ sub $31, $31, 0
// // \\ sub $31, $31, 0xffff
// \\ neg $31, $30
// \\ ori $0, $0, 0
// \\ ori $0, $0, 0xffff
// \\ ori $31, $31, 0
// \\ ori $31, $31, 0xffff
// \\ andi $0, $0, 0
// \\ andi $0, $0, 0xffff
// \\ andi $31, $31, 0
// \\ andi $31, $31, 0xffff

pub noinline fn fnc() void {
    // var xs: [3]usize = .{ 0, 1, 0 };
    // for (0..10) |i|
    //     xs[(i + 2) % 3] = xs[(i + 1) % 3] + xs[i % 3];
    // asm volatile (
    //     \\addi $s0, $zero, 15
    //     \\addi $s1, $zero, 24
    //     \\addi $s2, $zero, 2
    //     \\sub $t0, $s1, $s0
    //     \\and $t1, $s1, $s0
    //     \\or $t2, $s1, $s0
    //     \\xor $t3, $s1, $s0
    //     \\sllv $t4, $s2, $s2
    //     \\sub $s3, $zero, $s1
    //     \\srlv $t5, $s2, $s2
    //     \\srav $t6, $s2, $s2
    //     \\addi $s4, $zero, 7
    //     \\sub  $t7, $s0, $s4
    //     \\and  $t8, $s0, $s4
    //     \\or   $t9, $s0, $s4
    //     \\xor  $t0, $s0, $s4
    //     \\sllv $t1, $s2, $s4
    //     \\sub  $s5, $zero, $s4
    //     \\srlv $t2, $s2, $s4
    //     \\srav $t3, $s2, $s4
    //     \\addi $s6, $zero, 31
    // );
    asm volatile (
        \\        addi   $sp,$sp,-32
        \\        sw      $fp,28($sp)
        \\        add    $fp,$sp,$0
        \\        sw      $0,12($fp)
        \\        addi    $2,$0, 1                        # 0x1
        \\        sw      $2,16($fp)
        \\        sw      $0,20($fp)
        \\        sw      $0,8($fp)
        \\        j       $L2
        \\        nop
        \\
        \\$L3:
        \\        lw      $2,8($fp)
        \\        nop
        \\        addi   $3,$2,1;
        \\        addi      $2,$0,3                        # 0x3
        \\        div     $0,$3,$2
        \\        nop
        \\        mfhi    $2
        \\        sll     $2,$2,2
        \\        addi   $3,$fp,8
        \\        add    $2,$3,$2
        \\        lw      $3,4($2)
        \\        lw      $4,8($fp)
        \\        addi      $2,$0,3                        # 0x3
        \\        div     $0,$4,$2
        \\        nop
        \\        mfhi    $2
        \\        sll     $2,$2,2
        \\        addi   $4,$fp,8
        \\        add    $2,$4,$2
        \\        lw      $2,4($2)
        \\        lw      $4,8($fp)
        \\        nop
        \\        addi   $5,$4,2
        \\        addi      $4,$0,3                        # 0x3
        \\        div     $0,$5,$4
        \\        nop
        \\        mfhi    $4
        \\        add    $3,$3,$2
        \\        sll     $2,$4,2
        \\        addi   $4,$fp,8
        \\        add    $2,$4,$2
        \\        sw      $3,4($2)
        \\        lw      $2,8($fp)
        \\        nop
        \\        addi   $2,$2,1
        \\        sw      $2,8($fp)
        \\$L2:
        \\        lw      $2,8($fp)
        \\        nop
        \\        slt     $2,$2,10
        \\        bne     $2,$0,$L3
        \\        add    $sp,$fp,$0
        \\        lw      $fp,28($sp)
        \\        addi   $sp,$sp,32
        \\        jr      $31
        \\        nop
    );
}
