# 32-bit Pipelined RISC-V Microprocessor
This project is an implementation of a 32-bit 5-stage pipelined RISC-V microprocessor designed in Verilog HDL, verified through simulation and testbenches.
The processor supports basic RISC-V instructions with pipelining, hazard detection, and forwarding logic.

## Project Overview
Architecture: 5-stage pipeline (IF, ID, EX, MEM, WB)
Supported ISA: RISC-V

### Key Modules:
* Instruction Fetch Unit
* Decode & Register File
* Execute Unit (ALU)
* Memory Access Unit
* Writeback Unit
* Control Unit
* Hazard Detection Unit
**Verification**: Simulation waveforms and testbenches

### Features
* 5-stage pipelining with proper instruction flow.
* Hazard detection and forwarding to handle data hazards.
* Modular Verilog design for easy debugging.
* Simulation testbenches to verify different instructions.
* Planned future FPGA synthesis and hardware testing.
