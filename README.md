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

## Schematics

### Register file 
![Screenshot 2025-07-05 105755](https://github.com/user-attachments/assets/70f6e156-32b5-49f5-a76f-a307912b4b27)

### IF stage and IF_ID registers
![image](https://github.com/user-attachments/assets/ff3d8f81-1a30-46a3-8d47-3ded0836ba29)

### Extend Unit and ID_EX registers
![image](https://github.com/user-attachments/assets/2adf95e3-42a1-4ce6-981e-12ec9a4d3baa)

### EX Stage and EX_MEM registers
![image](https://github.com/user-attachments/assets/17d70aae-3568-4e2e-a3d1-5b25fa6c0554)

### MEM Stage
![image](https://github.com/user-attachments/assets/ac5ba735-a59e-41ef-88fa-5177d801b656)

### MEM_WB registers and WB Stage
![image](https://github.com/user-attachments/assets/fff04b40-1902-4b51-9c2b-0dd3abc3a039)

### Control Unit
![image](https://github.com/user-attachments/assets/638992ae-985e-4d81-951f-2fafd1c77312)

### Hazard Unit
![image](https://github.com/user-attachments/assets/0ca4c1e8-7610-4498-a1d0-566c96a09d6a)
