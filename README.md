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

## Simulations

This video shows the **first 5 instructions**. First the value of 5th and 6th registers are set to 0 and 1 respectively and as the branch is not taken the 7th and 8th instructions are set to the values 2 and 3 respectively.

https://github.com/user-attachments/assets/96e102cc-caed-4c6b-96c4-e134c8186d51

This video shows the **next 5 instructions**. As the branch is taken, the instruction setting 7th register to value 4 doesnt get executed and then the values of 8th register is set to 5 then 7th register to 6 and finally 8th register to 7.

https://github.com/user-attachments/assets/59e73880-4c64-4271-aab0-e580e15e7776

This video shows the **next 5 instructions**. As the branch is taken, the instruction setting 7th register to value 8 doesnt get executed and then the values of 8th register is set to 9 then 7th register to 10(a) and finally 8th register to 11(b).

https://github.com/user-attachments/assets/d7c9e883-a1d8-4139-981b-71da9dc0f4f6

This video shows the **next 3 instructions**. As the branch is not taken, both the intructions are executed and 7th register gets the value 12(c) and 8th register stores the value 13(d) respectively.

https://github.com/user-attachments/assets/c9b256d0-c1bc-4f4c-9845-8bdf3e9de6cb

This video shows the **next 5 instructions**. As the branch is taken, the instruction setting 7th register to value 14 doesnt get executed and then the values of 8th register is set to 15(f) then 7th register to 16(10) and finally 8th register to 17(11).

https://github.com/user-attachments/assets/d35f1e2a-d13b-4664-836e-44d10f9bae1f


