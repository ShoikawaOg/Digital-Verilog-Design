```markdown
# XNOR Gate

## Objective
Design and simulate a 2-input XNOR (Exclusive NOR) gate using Verilog HDL.

## Description
The XNOR (Exclusive NOR) gate produces a HIGH (`1`) output only when **both inputs are the same** (both `0` or both `1`). If the inputs are different, the output becomes LOW (`0`). It is the complement of the XOR gate and is commonly used in equality checking and comparison circuits.

## Truth Table

| A | B | Y |
|:-:|:-:|:-:|
| 0 | 0 | 1 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

## Verilog Files

- `xnor_gate.v` – Verilog module implementing the XNOR gate.
- `xnor_gate_tb.v` – Testbench used to verify the design.

## Simulation

The design was simulated using **Xilinx Vivado**. The simulation waveform verifies that the output is HIGH only when both inputs are identical, matching the XNOR gate truth table.

## Software Used

- Xilinx Vivado
- Verilog HDL

## Applications

- Equality Comparators
- Error Detection Systems
- Parity Checking
- Digital Control Circuits
- Pattern Recognition and Data Verification

## Result

The 2-input XNOR gate was successfully designed, simulated, and verified. The simulation results matched the expected logical behavior.

## Simulation Waveform

![XNOR Gate Waveform](waveform.png)
```
