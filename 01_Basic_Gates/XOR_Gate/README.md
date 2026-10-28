```markdown
# XOR Gate

## Objective
Design and simulate a 2-input XOR (Exclusive OR) gate using Verilog HDL.

## Description
The XOR (Exclusive OR) gate produces a HIGH (`1`) output only when **the two inputs are different**. If both inputs are the same (both `0` or both `1`), the output is LOW (`0`). XOR gates are widely used in arithmetic circuits, parity generation, and error detection systems.

## Truth Table

| A | B | Y |
|:-:|:-:|:-:|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

## Verilog Files

- `xor_gate.v` – Verilog module implementing the XOR gate.
- `xor_gate_tb.v` – Testbench used to verify the design.

## Simulation

The design was simulated using **Xilinx Vivado**. The simulation waveform verifies that the output is HIGH only when the inputs are different, matching the XOR gate truth table.

## Software Used

- Xilinx Vivado
- Verilog HDL

## Applications

- Half Adder and Full Adder circuits
- Parity Generator and Parity Checker
- Error Detection and Correction
- Binary Comparators
- Data Encryption and Digital Communication Systems

## Result

The 2-input XOR gate was successfully designed, simulated, and verified. The simulation results matched the expected logical behavior.

## Simulation Waveform

![XOR Gate Waveform](waveform.png)
```
