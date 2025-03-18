- [Persian version](Readme-fa.md)
- [Homework 1](#homework-1)
- [Homework 2](#homework-2)
- [Homework 3](#homework-3)

# Computer Architecture Course, Practical Homework Grading System

## Prerequisites

To run this system, you will need the following programs:

```bash
# iverilog
# python (python-is-python3)
# ubuntu/debian (apt):
sudo apt install iverilog python3 python-is-python3
# arch (pacman)
sudo pacman -S iverilog python
```

### How the Grading System Works

The grading system consists of two main components:

1. **Helper Scripts**:

   - `./synthesize.sh`:
     This script synthesizes your circuit description into Verilog code.
     The synthesized description is placed in the `~/logisim_evolution_workspace/` directory.
   - `./validate.sh`:
     This script takes the given test bench (related to the specific question)
     and the location of the synthesized description, tests the designed circuit, and assigns a score.
   - `./synth_valid.sh`:
     This script essentially combines the two previous scripts. It first performs the synthesis process and then evaluates the synthesized output.

2. **Test Bench Files**:
   These files contain the logic for creating various tests and verifying the correctness
   of your circuit. Since these files include the scoring logic, you can use them to debug and fix issues in your circuits.

## Homework 1

In this homework, you will design a 4-bit adder/subtractor.

The ports of this circuit are as follows:

```verilog
input [3:0] a
input [3:0] b
input sub_notadd
output [3:0] s
output cout
```

Based on what you have learned in previous courses, such a circuit can be described as follows:

```verilog
sub_notadd  :    {cout , s} = a + b
!sub_notadd :    {cout , s} = a + ~b + 1
```

The evaluation of this exercise is done with the following command:

```bash
./synth_valid.sh ./HW1/bench.circ ./HW1/tb0.v
```

Since this is the first exercise, it is primarily intended for practice
and familiarization with the grading system. The answer is essentially provided
in the file `./HW1/bench.circ`, and you only need to execute and review it in your report.
However, given that you will encounter much more complex circuits later in the course,
I strongly recommend that you take this opportunity to get comfortable with using `logisim` and design this circuit on your own.

## Homework 2

### Question 1

Design a circuit that operates according to the following instructions:

```
load:   rl <= in1
0:      r2 <= -r1
1:      r2 <= r1 & r2
2:      r2 <= -r2
3:      out1 <= r1 + r2
        r2   <= r1 + r2
```

The ports of this circuit are as follows:

```verilog
input [31:0] in1
input load
input clk
output [31:0] out1
```

The evaluation of this question is done with the following command:

```bash
./synth_valid.sh schematic.circ ./HW2/tb1.v
```

### Question 2

Design the circuit according to the flowchart below:

<center>
<img src='images/2q2.jpg'/>

Note that {a,q} means placing the bits of `a` to the left (more significant bits) of the bits of `q`.

</center>

The ports of this circuit are as follows:

```verilog
input [31:0] divisor
input [31:0] dividend
input start
input clk
output [31:0] quotient
output [31:0] remainder
output done
```

The evaluation of this question is done with the following command:

```bash
./synth_valid.sh schematic.circ ./HW2/tb2.v
```

## Homework 3

In this exercise, we will build the Arithmetic Logic Unit (ALU) of the processor!
This unit is generally divided into three parts: preparation, computation, and output generation.
Note that this division is a personal interpretation, and you may have your own interpretation as well.

The ports of this circuit are as follows:

```verilog
input [31:0] a
input [31:0] b
input [ 3:0] aluop
input output_inverted
input output_inc
input clk
input rst
output [31:0] res_low
output [31:0] res_high
output done
```

This unit is responsible for computing all the arithmetic and logical operations required at the register level in our system. Therefore, it must support the following instructions using `aluop`:

0. **ADD**:
   Implement this operation using the Carry Select Adder algorithm with 4-bit block lengths.
1. **SUB**:
   Implement the subtractor with minor modifications to the adder (you can use bit 0 as `sub_not_add`).
2. **MUL**:
   Perform unsigned multiplication of `a` and `b` using an improved version of the shift-and-add algorithm (using Carry Save Adder at each step, advancing 2 digits at a time). For correct operation, this requires a `start` signal, which you can obtain by comparing the current request with the last issued request.
3. **DIV**:
   Implement this using the algorithm you developed in the previous homework. Since the algorithm from the previous homework also requires a `start` signal, you can generate it using the same technique as above.
4. **AND**
5. **OR**
6. **XOR**
7. **CLO**:
   This operation counts the number of leading 1s in `a`. For implementation ideas, refer to the [attached Verilog code](HW3/alu.v).
8. **CLZ**:
   Similarly, this operation counts the number of leading 0s in `a`.
9. **SLL** (Shift Left Logical)
10. **SRL** (Shift Right Logical)
11. **SRA** (Shift Right Arithmetic)
12. **ROTR** (Rotate Right)

After performing these operations, to keep the number of ALU opcodes logical, in addition to the operation specified by the opcode, we must also consider `output_inverted` and `output_inc`. In this case, the output will be as follows:

```verilog
output_inverted  :  {res_high, res_low} =~{calc_high, calc_low} + output_inc
!output_inverted :  {res_high, res_low} = {calc_high, calc_low} + output_inc
```

Finally, the evaluation of this homework is done with the following command:

```bash
./synth_valid.sh schematic.circ ./HW3/tb.v
```
