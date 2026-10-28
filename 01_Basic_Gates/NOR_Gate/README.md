```markdown
# NOR Gate

## Objective
Design and simulate a 2-input NOR gate using Verilog HDL.

## Description
The NOR gate (NOT-OR) is a universal digital logic gate. It produces a HIGH (`1`) output only when **both inputs are LOW (`0`)**. If either input is HIGH (`1`), the output becomes LOW (`0`). Like the NAND gate, the NOR gate can be used to implement any digital logic circuit.

## Truth Table

| A | B | Y |
|:-:|:-:|:-:|
| 0 | 0 | 1 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 0 |

## Verilog Files

- `nor_gate.v` – Verilog module implementing the NOR gate.
- `nor_gate_tb.v` – Testbench used to verify the design.

## Simulation

The design was simulated using **Xilinx Vivado**. The simulation waveform confirms that the output is HIGH only when both inputs are LOW, matching the NOR gate truth table.

## Software Used

- Xilinx Vivado
- Verilog HDL

## Applications

- Universal gate for implementing any digital logic circuit
- SR latch and memory elements
- Digital control systems
- Logic inversion and combinational circuits
- Embedded and FPGA-based digital designs

## Result

The 2-input NOR gate was successfully designed, simulated, and verified. The simulation results matched the expected logical behavior.

## Simulation Waveform

![NOR Gate Waveform](waveform.png)
```
