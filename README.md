# Pipeline Processor

## Overview

The Architecture-Project is centered around the design and implementation of a simple 5-stage pipelined processor following a RISC-like instruction set architecture (ISA). The processor is von Neumann based and consists of key components such as general-purpose registers, program counter (PC), stack pointer (SP), and memory.

## Processor Specifications

- **Registers:** Eight 4-byte general-purpose registers (R0 to R7), a program counter (PC), and a stack pointer (SP).
- **Memory:** 4 KB of 16-bit word-addressable memory. The data bus width between memory and the processor is 16 bits for instruction memory and 32 bits for data memory.
- **Pipeline Stages:**
  1. **Fetch**
  2. **Decode**
  3. **Execute**
  4. **Memory**
  5. **Write Back**

## Instruction Set Architecture (ISA)

The ISA is designed with a RISC-like approach, emphasizing simplicity and efficiency. The instruction set includes various operations, and the format of instructions is illustrated in the provided images.

![ISA_1](https://i.imgur.com/MsL9zGb.png)
![ISA_2](https://i.imgur.com/JUL2QdB.png)
![ISA_3](https://i.imgur.com/wkRqyRg.png)

## Control Signals

The control signals used in the processor are documented in a Google Spreadsheet. This includes signals for each stage of the pipeline, enabling the control of various operations during the fetch, decode, execute, memory, and write back stages. [Control Signals Spreadsheet](https://docs.google.com/spreadsheets/d/120m1b6FrHCg9PQZ74T6VtSyrkmBFBvLhuMwCTFt1aC0/edit#gid=0)

## Schematic Diagram

The schematic diagram of the processor is visualized using an online drawing tool. It provides an overview of the components and their connections in the system. [Schematic Diagram](https://www.tldraw.com/v/dJRQlmzGx5PjeXC4-ebE3?viewport=-17878,-12089,25600,14387&page=page:page)  
  
 
  
## Assembler

The assembler for this processor translates human-readable assembly code into machine code that the processor can execute.
enabling programmers to write code at a higher level and then convert it into the binary format understandable by the processor.

To assemble your code, use the following command:
```
python assembler.py -i code.txt -o "output_file"
```



## Contributors <a name = "Contributors"></a>

<table>
  <tr>
    <td align="center">
    <a href="https://github.com/mostafaelsayed2002" target="_blank">
    <img src="https://avatars.githubusercontent.com/u/24477303?v=4" width="150px;" alt="Mostafa Elsayed"/>
    <br />
    <sub><b>Mostafa Elsayed</b></sub></a>
    </td>
    <td align="center">
    <a href="https://github.com/MohamedMaher02" target="_blank">
    <img src="https://avatars.githubusercontent.com/u/102810425?v=4" width="150px;" alt="Mohamed Maher"/>
    <br />
    <sub><b>Mohamed Maher</b></sub></a>
    </td>
    <td align="center">
    <a href="https://github.com/Aly-Abdel-Motaleb" target="_blank">
    <img src="https://avatars.githubusercontent.com/u/94588581?v=4" width="150px;" alt="Aly-Abdel-Motaleb"/>
    <br />
    <sub><b>Aly Abdel Motaleb</b></sub></a>
    </td>
    <td align="center">
    <a href="https://github.com/Walid-Kh" target="_blank">
    <img src="https://avatars.githubusercontent.com/u/94529949?v=4" width="150px;" alt="Walid Khamees"/>
    <br />
    <sub><b>Walid Khamees</b></sub></a>
    </td>
  </tr>

 </table>
