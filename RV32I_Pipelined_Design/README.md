# Pipeline-RISCV

5-stage pipelined RISC-V soft-core processor implemented in Verilog with a Hazard Unit. It is based on the RV32i Instruction Set in which all the instructions are implemented with the exception of _fence_, _ecall_, _ebreak_ and _csrr-based_. Unitary and integration tests are provided [here](https://github.com/joscarvalho/Pipeline-RISCV/tree/main/instructions_tests).


The implemented processor diagram and correspondent design are shown below.

<p align="center">
    <b> </b><br>
    <br>
    <img width="800" src="https://github.com/joscarvalho/Pipeline-RISCV/blob/main/Img/Pipeline%20Diagram.jpg?raw=true" alt="RISC-V Soft-core Processor Structure Diagram"/>
</p>

<p align="center">
    <b> </b><br>
    <br>
    <img width="700" src="https://github.com/joscarvalho/Pipeline-RISCV/blob/main/Img/Pipeline%20Design.png?raw=true" alt="RISC-V Soft-core Processor Design"/>
</p>

### Authors:
- [José Carvalho](https://github.com/Jose-Carvalho-88240)
- [Hugo Ribeiro](https://github.com/HugoRibeiro-A88287-UM)
- [João Carneiro](https://github.com/JoaoLuis00)
