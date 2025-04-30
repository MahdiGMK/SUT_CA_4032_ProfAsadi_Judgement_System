const std = @import("std");
const io = std.io;
const fs = std.fs;
// MIPS little endian
const Instruction = packed struct {
    detail: packed union {
        J: u26,
        I: packed struct { imm: i16, rt: u5, rs: u5 },
        R: packed struct { func: u6, shmt: u5, rd: u5, rt: u5, rs: u5 },
    },
    opcode: u6,
};

/// extract from a LOAD header with RE flags in
/// ```bash
/// readelf -l mips-exe
/// ```
const foff = 0x000350;
const voff = 0x00020350;

/// function address
/// ```bash
/// nm -C --defined-only mips-exe | rg fnc
/// ```
const vaddr = 0x000207c0;

const num_inst = 60;

pub fn main() !void {
    const f =
        try fs.cwd().openFile("mips-exe", .{});

    try f.seekTo(vaddr - voff + foff);
    var buf: [num_inst]u32 = undefined;
    _ = try f.read(std.mem.asBytes(&buf));

    var stdout = io.getStdOut().writer();

    for (buf, 0..) |bits, idx| {
        // std.debug.print("{x:0>8}\n", .{inst});
        // stdout.print("{b:0>32}\n", .{(inst)});
        // const decompose: Instruction = @bitCast(inst);
        // if (decompose.opcode == 0) {
        //     std.debug.print("{} {}\n", .{ decompose.detail.R, decompose.opcode });
        // } else std.debug.print("{} {}\n", .{ decompose.detail.I, decompose.opcode });

        // verilog format
        var inst: Instruction = @bitCast(bits);
        if (inst.opcode == 0b000010)
            inst.detail.J -= vaddr >> 2;
        try stdout.print(
            "instructions[{}] = 32'b{b:0>32};\n",
            .{ idx, @as(u32, @bitCast(inst)) },
        );
    }
}
