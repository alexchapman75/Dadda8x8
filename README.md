# 8x8 Dadda Tree Multiplier

Gate-level Verilog implementation of an 8-bit x 8-bit unsigned Dadda tree multiplier, built for my ECE 310 (Digital Logic Design) Project 1. Includes a basic directed-vector testbench per project requirements, and an extended SystemVerilog testbench with constrained-random stimulus and functional coverage.

## Overview

The design multiplies two 8-bit unsigned inputs (`a`, `b`) into a 16-bit unsigned product (`prod`) entirely at the gate level:

1. **Partial product generation** — 64 AND gates form the full 8x8 partial product matrix.
2. **Dadda reduction** - the matrix height is reduced from 8 down to 2 across four stages (targeting heights 6, 4, 3, 2), using a mix of gate-level Half Adders and Full Adders.
3. **Final addition** — the two remaining rows are combined using a 14-bit ripple-carry adder to produce the final 16-bit product.

| Unit | Count |
|---|---|
| AND gates | 64 |
| Half Adders (Dadda reduction) | 7 |
| Full Adders (Dadda reduction) | 35 |
| **Total Half Adders** | **8** |
| **Total Full Adders** | **48** |

## Repository Contents

| File | Description |
|---|---|
| `Dadda8x8.v` | Top-level gate-level multiplier design (DUT). |
| `Dadda8x8_tb.v` | Basic self-checking Verilog testbench with 6 directed test vectors covering standard and edge-case inputs. |
| `Dadda8x8_tb_sv.sv` | Extended SystemVerilog testbench with constrained-random stimulus, functional coverage (including cross-coverage), and self-checking against an expected reference model. |
| `Project1_Report.pdf` | Formal report covering design methodology, gate counts, test vector reasoning, and simulation results. |

## Running the Simulation

### Basic testbench (`Dadda8x8_tb.v`)
1. Create a new Vivado project and add `Dadda8x8.v` and `Dadda8x8_tb.v` as sources (mark the testbench as a simulation source).
2. Run Behavioral Simulation.
3. The testbench applies 6 directed vectors (all-ones, alternating bits, nibble-aligned, general case, all-zeros, minimal non-zero), checks each `prod` output against a golden expected value, and reports `PASS`/`FAIL` results in the Tcl console.

### Extended testbench (`Dadda8x8_tb_sv.sv`)
1. Add `Dadda8x8_tb_sv.sv` to the project as a simulation source (ensure Vivado treats it as SystemVerilog, not plain Verilog, in the Sources panel).
2. Run Behavioral Simulation.
3. The testbench runs the same 6 directed corner cases first, then 200 constrained-random vectors weighted toward boundary values (`0x00`, `0xFF`).
4. At the end of the run, the console reports total tests run, failures, and overall functional coverage percentage across the `a`/`b` coverpoints and their cross-coverage bins.

## Test Vectors (Directed)

| a | b | Expected prod | Purpose |
|---|---|---|---|
| `11111111` | `11111111` | `1111111000000001` | All-ones edge case; max height carry propagation |
| `10101010` | `01010101` | `0011100001110010` | Alternating bit pattern |
| `00001111` | `11110000` | `0000111000010000` | Nibble-aligned pattern |
| `10011100` | `01101101` | `0100001001101100` | General non-trivial case |
| `00000000` | `11111111` | `0000000000000000` | All-zero edge case |
| `00000001` | `00000001` | `0000000000000001` | Minimal non-zero case |

## References

- ["Dadda multiplier," Wikipedia.](https://en.wikipedia.org/wiki/Dadda_multiplier)
- Stianmat, ["Dadda tree 8x8,"](https://commons.wikimedia.org/wiki/File:Dadda_tree_8x8.svg) Wikimedia Commons, licensed under CC BY 3.0.
