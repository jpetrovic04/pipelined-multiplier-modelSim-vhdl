# Signed Pipelined Multiplier (VHDL)

A parameterized, fully pipelined $N \times N$-bit signed array multiplier implemented in VHDL. The design performs two's complement multiplication using a ripple-carry adder tree, sign-extension logic, and multi-stage pipeline registers to achieve high clock frequency and a throughput of one multiplication per clock cycle.

## Key Features
* **Parameterized Bit-Width:** Configurable operand width via VHDL `generic (N : natural := 10)`.
* **Two's Complement Arithmetic:** Supports signed multiplication using Baugh-Wooley-style partial product inversion (`sel` control logic) and sign extension.
* **Pipelined Architecture:**
  * **Input Delay Lines:** Shift registers (`regA`, `regB`) synchronize input operands across pipeline stages.
  * **Inter-Stage Registers:** Pipeline registers between adder rows store intermediate partial sums (`sig`) on each rising clock edge.
  * **Output Alignment Chain:** Variable-length D flip-flop (DFF) delay lines (`N - i` stages) align lower product bits (`zp`) so all $2N$ output bits appear simultaneously.
* **Performance:**
  * **Latency:** $N + 1$ clock cycles from input to valid output.
  * **Throughput:** 1 result per clock cycle (once the pipeline is filled).

## Repository Structure
* `adder.vhd` — Parameterized $N$-bit ripple-carry adder component.
* `pipelined_multiplier.vhd` — Top-level structural architecture of the pipelined multiplier.
* `testbenc.vhd` — Self-contained testbench verifying positive, negative, and boundary 8-bit signed values.
* `images/` — Block schematic and ModelSim simulation waveforms.

## Entity Interface

| Port / Generic | Direction | Width | Description |
| :--- | :---: | :---: | :--- |
| `N` | Generic | `natural` | Bit-width of input operands (default: `10`) |
| `clk` | Input | 1 bit | System clock (rising-edge triggered) |
| `rst` | Input | 1 bit | Asynchronous active-high reset |
| `a` | Input | `N` bits | Signed multiplicand (2's complement) |
| `b` | Input | `N` bits | Signed multiplier (2's complement) |
| `z` | Output | `2*N` bits | Signed product output (2's complement) |

## Simulation & Verification

The design was verified in **Intel ModelSim** with `N = 8` using corner-case signed inputs:
* `(-3) × (-3) = 9` (`0x0009`)
* `(-3) × 3 = -9` (`0xFFF7`)
* `3 × 3 = 9` (`0x0009`)
* `(-128) × (-128) = 16384` (`0x4000`)
* `127 × (-128) = -16256` (`0xC080`)

### How to Run (ModelSim / QuestaSim)
1. Compile the source files in order: `adder.vhd`, `pipelined_multiplier.vhd`, and `testbenc.vhd`.
2. Start simulation on `work.pipelined_multiplier_tb`.
3. Add top-level signals (`clk`, `rst`, `a`, `b`, `z`) to the Wave window and set the radix to **Signed / Decimal**.
4. Run the simulation for `600 ns`.

### Simulation Waveform
![Simulation Waveform](images/waveform.png)

*(Note: Intermediate transient values visible for 1 clock cycle between consecutive results occur as new operands propagate through the pipeline stages before all output bits align.)*
