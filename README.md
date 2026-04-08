# Design and Implementation of a High-Performance 16-Bit DSP ALU Using Six-Stage Pipelining

### **Research Supplement | IEEE IC2PCT 2026**

This repository contains the **Verilog HDL** source code and implementation files for a high-throughput, 16-bit pipelined Arithmetic Logic Unit (ALU). The architecture is specifically optimized for the **Xilinx Artix-7 FPGA** fabric, leveraging dedicated hardware primitives to overcome the performance bottlenecks of conventional combinatorial designs.

---

## Technical Overview
Modern high-frequency signal processing requires ALUs that balance propagation delay and power consumption. This project implements a **six-stage pipeline** that isolates critical timing paths, allowing for a deterministic operating frequency suitable for streaming DSP applications.

### **Key Features**
* **Architecture:** 6-stage synchronous pipeline designed to decouple throughput from combinatorial complexity.
* **Hard-Macro Inference:** Explicitly targets **DSP48E1 slices** for 16-bit multiplication and **CARRY primitives** for high-speed addition/subtraction.
* **Latency Balancing:** Implements register retiming and shift-register propagation to synchronize single-cycle arithmetic with multi-cycle DSP operations.
* **Resource Efficiency:** Occupies a minimal footprint of only **87 LUTs** (0.13% utilization) by offloading complex switching to hardened logic.

---

## Performance Metrics
The design was validated and implemented on the **Digilent Nexys 4 DDR** (Xilinx Artix-7 XC7A100T) platform.

| Metric | Value |
| :--- | :--- |
| **Max Operating Frequency ($F_{max}$)** | **100 MHz** (Nexys 4 DDR Baseline) |
| **Dynamic Power Consumption** | **0.025 W** |
| **Critical Path Delay** | **~5.29 ns** |
| **Worst Negative Slack (WNS)** | **+4.614 ns** |
| **Total On-Chip Power** | **0.129 W** |

Full Synthesis Utilization, Implementaion Timing, and Power reports are available in the [reports/](https://github.com/animesh9364/DSP-ALU-6-Stage-Pipelined-VLSI/reports) directory.

---

## Development Tools
* **HDL:** Verilog HDL
* **Synthesis & Simulation:** Xilinx Vivado Design Suite
* **Hardware Target:** Digilent Nexys 4 DDR (Artix-7 xc7a100t-csg324-1)

---

## Citation & Publication
This work has been accepted for presentation at the **2026 4th International Conference on Innovative Computing, Intelligent Communication and Smart Electrical Systems (ICSES)**—**IEEE IC2PCT**, May 2026.

**Author:** Abhishek Mohanty, Animesh Biswas, Sarita Nanda and Kananbala Ray  
**Department:** Electronics & Telecommunication Engineering, KIIT University

---

## License
This project is licensed under the **MIT License**. See the `LICENSE` file for details.
