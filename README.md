# 🧠 AMBA APB-Based Multi-Slave Memory-Mapped System

![Project Block Diagram](img)

## 📌 Summary

This project implements a fully Verilog-based system that emulates a memory-mapped architecture using the AMBA APB protocol. It includes a configurable wrapper that interfaces with multiple APB slaves, with detailed attention to clean address decoding, safe signal multiplexing, and realistic memory behavior. The system is scalable, modular, and designed with SoC prototyping in mind.

---

## 📖 Project Description

This APB system provides a fundamental platform to demonstrate how multiple memory-mapped peripherals can communicate via a shared APB bus. The system includes:

### 🔧 Components

- **APB Wrapper:**
  Acts as the central interconnect and arbitrator. It:
  - Decodes address ranges to select the correct APB slave.
  - Forwards signals such as `PADDR`, `PWRITE`, `PWDATA`, and control handshakes.
  - Uses *safe multiplexing logic* to return only one slave’s output (e.g., `PRDATA`, `PREADY`, `PSLVERR`) at a time — ensuring no multi-driver contention.
  - Supports flexible address mapping, easily adjustable per system requirements.

- **Slave Modules:**
  - Each slave features:
    - 32-bit data bus
    - Memory depth of 8KB, addressable word-by-word
    - Internal memory implemented as simple Verilog RAM

- **Testbench:**
  A dedicated simulation environment to verify functional correctness. It covers both read and write operations, with varying timing responses.

### 💡 System Behavior

- **Address Mapping Example**:
  - `0x0000_0000 – 0x0000_001F`: Mapped to Slave 0
  - `0x0000_0020 – 0x0000_003F`: Mapped to Slave 1
  These regions can be easily changed depending on the SoC layout.

- **Multiplexing Return Signals**:
  Only the active slave’s output is routed to the APB master using conditional logic. This eliminates signal collisions and guarantees deterministic behavior.

- **Extensibility**:
  The slaves can be easily replaced with real peripherals such as UART, SPI, or GPIO controllers, making the design highly modular and reusable.

---

## 🚀 Future Work

- **UVM Testbench**: The next logical step is building a UVM environment to provide layered, reusable verification components for functional and timing correctness.
- **Integration into SoC**: This APB system can serve as part of a larger SoC architecture, interfacing with a custom ISA or microcontroller core.
- **AXI/APB Bridges**: Future enhancements may include adding protocol bridges to integrate APB peripherals into AXI-based systems.

---


تحرير
