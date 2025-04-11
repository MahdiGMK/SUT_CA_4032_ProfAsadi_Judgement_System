# A small toolbox for observing mips32(little endian)

# Prerequisites

[Zig](https://ziglang.org/)

# Compile to mips(el)

```bash
zig build-exe inline_asm.zig -target mipsel-linux -O ReleaseSmall -fno-strip --name mips-exe
```

# Intruction extraction

firstly, resolve following fields in readbin.zig

````zig
/// extract from a LOAD header with RE flags in
/// ```bash
/// readelf -l mips-exe
/// ```
const foff = 0x000330;
const voff = 0x00020330;

/// function address
/// ```bash
/// nm -C --defined-only mips-exe | rg fnc
/// ```
const vaddr = 0x000207b0;
````

then, execute using :

```bash
zig run readbin.zig
```
