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
    asm volatile (
        \\j main
        \\nop
        \\nop
        \\
        \\fibo:
        \\addi $v0 , $zero , 1
        \\addi $t0 , $zero , 1
        \\beqz $a0 , done
        \\nop
        \\nop
        \\loop:
        \\add $t1 , $v0 , $zero
        \\add $v0 , $v0 , $t0
        \\nop
        \\nop
        \\nop
        \\addi $a0 , $a0 , -1
        \\add $t0 , $t1 , $zero
        \\nop
        \\nop
        \\nop
        \\bnez $a0 , loop
        \\nop
        \\nop
        \\done:
        \\jr $ra
        \\nop
        \\nop
        \\
        \\main:
        \\addi $sp , $sp , -8
        \\nop
        \\nop
        \\nop
        \\nop
        \\sw $ra , ($sp)
        \\addi $a0 , $zero , 12
        \\nop
        \\nop
        \\nop
        \\jal fibo
        \\nop
        \\nop
        \\lw $ra , ($sp)
        \\addi $sp , $sp , 8
        \\nop
        \\nop
        \\nop
        \\nop
        \\nop
        \\nop
        \\nop
        \\nop
    );
}

pub noinline fn func(n: u32) u32 {
    if (n == 0) return 1;
    return @truncate(n * func(n - 1));
}
