# Design and Implementation of a High-Performance 16-Bit DSP ALU Using Six-Stage Pipelining

### **Research Supplement | IEEE IC2PCT 2026**

[cite_start]This repository contains the **Verilog HDL** source code and implementation files for a high-throughput, 16-bit pipelined Arithmetic Logic Unit (ALU)[cite: 399, 403]. [cite_start]The architecture is specifically optimized for the **Xilinx Artix-7 FPGA** fabric, leveraging dedicated hardware primitives to overcome the performance bottlenecks of conventional combinatorial designs[cite: 398, 399].

---

## Technical Overview
[cite_start]Modern high-frequency signal processing requires ALUs that balance propagation delay and power consumption[cite: 397, 406]. [cite_start]This project implements a **six-stage pipeline** that isolates critical timing paths, allowing for a deterministic operating frequency suitable for streaming DSP applications[cite: 412, 438, 495].

### **Key Features**
* [cite_start]**Architecture:** 6-stage synchronous pipeline designed to decouple throughput from combinatorial complexity[cite: 442, 503].
* [cite_start]**Hard-Macro Inference:** Explicitly targets **DSP48E1 slices** for 16-bit multiplication and **CARRY primitives** for high-speed addition/subtraction[cite: 400, 413, 455].
* [cite_start]**Latency Balancing:** Implements register retiming and shift-register propagation to synchronize single-cycle arithmetic with multi-cycle DSP operations[cite: 401, 413, 453].
* [cite_start]**Resource Efficiency:** Occupies a minimal footprint of only **87 LUTs** (0.13% utilization) by offloading complex switching to hardened logic[cite: 468, 474, 503].

---

## Performance Metrics
[cite_start]The design was validated and implemented on the **Digilent Nexys 4 DDR** (Xilinx Artix-7 XC7A100T) platform[cite: 411, 437].

| Metric | Value |
| :--- | :--- |
| **Max Operating Frequency ($F_{max}$)** | [cite_start]**100 MHz** (Nexys 4 DDR Baseline) [cite: 412, 477] |
| **Dynamic Power Consumption** | [cite_start]**0.025 W** [cite: 483, 488] |
| **Critical Path Delay** | [cite_start]**~5.29 ns** [cite: 476] |
| **Worst Negative Slack (WNS)** | [cite_start]**+4.614 ns** [cite: 489] |
| **Total On-Chip Power** | [cite_start]**0.129 W** [cite: 481] |

---

## Development Tools
* [cite_start]**HDL:** Verilog HDL [cite: 403]
* **Synthesis & Simulation:** Xilinx Vivado Design Suite [cite: 399, 465]
* [cite_start]**Hardware Target:** Digilent Nexys 4 DDR (Artix-7 xc7a100t-csg324-1) [cite: 399, 450]

---

## Citation & Publication
[cite_start]This work has been accepted for presentation at the **2026 4th International Conference on Innovative Computing, Intelligent Communication and Smart Electrical Systems (ICSES)**—**IEEE IC2PCT**, May 2026[cite: 442, 503].

[cite_start]**Author:** Animesh Biswas [cite: 339]  
[cite_start]**Department:** Electronics & Telecommunication Engineering, KIIT University [cite: 340, 342]

---

## License
This project is licensed under the **MIT License**. See the `LICENSE` file for details.
