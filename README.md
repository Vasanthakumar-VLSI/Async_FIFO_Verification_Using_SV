# Dual-Clock Asynchronous FIFO Verification Environment

[cite_start]A robust, object-oriented, layered verification testbench built from scratch in **SystemVerilog** to rigorously validate a dual-clock Asynchronous FIFO design[cite: 1, 9]. [cite_start]The architecture implements transactors, dynamic transaction-level mailboxes [cite: 7][cite_start], reference modeling via standard queues [cite: 14][cite_start], and dedicated synchronization structures to handle multi-clock domain simulations[cite: 1, 16].

---

## 🏗️ System Architecture & Layered Testbench

[cite_start]The environment separates the test infrastructure into distinct layers to isolate stimulus generation from bus-level protocols and self-checking mechanisms[cite: 9, 10, 20].



### 1. Verification Hierarchy
* [cite_start]**Top Module (`top`)**: Generates independent, asynchronous write and read clocks (`wt_clk`, `rd_clk`), handles global reset (`rst`), instantiates the design under test (DUT), and passes interfaces to the environment[cite: 16].
* [cite_start]**Environment (`fifo_env`)**: The structural container that instantiates and coordinates the parallel execution of the Write Agent, Read Agent, and Scoreboard[cite: 9].
* **Write Agent (`fifo_wt_agent`)**: Encapsulates components driving the write domain, including the generator, bus functional model (BFM), monitor, and coverage collector[cite: 20].
* [cite_start]**Read Agent (`fifo_rd_agent`)**: Encapsulates components managing the read domain, mirroring the write agent's structural pattern[cite: 10].

### 2. Transactors & Communication
* [cite_start]**Transaction Objects (`wt_tx`, `rd_tx`)**: Data-containers defining randomized variables (like `w_data`, `wt_en`, `rd_en`) and tracking control flags (`full`, `empty`, `overflow`, `underflow`) captured from the pins[cite: 12, 22].
* [cite_start]**Inter-Process Mailboxes**: Static, type-safe FIFO mailboxes (`wt_gen2bfm`, `rd_gen2bfm`, etc.) safely pass transaction payloads between parallel executing tasks across different agents[cite: 7, 9].

---

## ⚙️ Detailed Functionality Explanation

### 1. Asynchronous Clock Domain Crossing (CDC) Handling
[cite_start]The design features independent clock domains for write (`wt_clk`) and read (`rd_clk`) operations[cite: 1]. To calculate status flags without causing metastability, internal pointers are captured and synchronized across domains:
* [cite_start]**Write Domain Synchronization**: The read pointer (`rd_ptr`) and read toggle flag (`rd_toggle_f`) are sampled on the rising edge of `wt_clk` into tracking registers (`rd_ptr_wt_clk`, `rd_toggle_f_wt_clk`)[cite: 1, 2].
* [cite_start]**Read Domain Synchronization**: The write pointer (`wt_ptr`) and write toggle flag (`wt_toggle_f`) are captured on the rising edge of `rd_clk` into tracking registers (`wt_ptr_rd_clk`, `wt_toggle_f_rd_clk`)[cite: 1, 2].

### 2. Flag Generation Logic
[cite_start]Flags are dynamically determined using combinations of the tracking pointers and toggle bits to evaluate boundary depth[cite: 5]:
* **Full Condition (`full`)**: Triggered when the write pointer catches up to the synchronized read pointer, but the operations have split across memory wraps (`wt_ptr == rd_ptr_wt_clk && wt_toggle_f != rd_toggle_f_wt_clk`)[cite: 5].
* [cite_start]**Empty Condition (`empty`)**: Triggered when the read pointer matches the synchronized write pointer on the same wrap line, meaning no unread data remains (`rd_ptr == wt_ptr_rd_clk && rd_toggle_f == wt_toggle_f_rd_clk`)[cite: 5].
* [cite_start]**Overflow Handling**: If a write is attempted (`wt_en == 1`) while the FIFO is full (`full == 1`), the module blocks further memory cell writes and asserts the `overflow` status bit[cite: 3].
* [cite_start]**Underflow Handling**: If a read is attempted (`rd_en == 1`) while the FIFO is empty (`empty == 1`), the module blocks memory fetching and asserts the `underflow` status bit[cite: 4].

### 3. Scoreboard Reference Modeling & Self-Checking Mechanics
[cite_start]The scoreboard (`fifo_sbd`) runs two concurrent execution threads using a SystemVerilog `fork-join` mechanism[cite: 9]:
* **Write Monitor Path**: Continuously monitors the write channel mailbox (`fifo_common::wt_mon2sbd`). [cite_start]When a transaction reports a valid write operation (`tx.wt_en == 1`), the written payload (`tx.w_data`) is pushed directly into an internal golden reference queue (`que.push_back`)[cite: 14].
* **Read Monitor Path**: Monitors the read channel mailbox (`fifo_common::rd_mon2sbd`). [cite_start]When data is removed, the scoreboard pops the front entry out of its golden queue (`que.pop_front`) and performs an assertion check against the real hardware output data (`tx1.r_data`)[cite: 14, 15].
* **Result Reporting**: Scoreboard matches increment a global `matching` counter, while data corruptions or sequence anomalies increment a `mismatching` counter[cite: 15]. The test bench uses these statistics at the end of simulation to print an absolute `Test Passed` or `Test Failed` status message[cite: 17, 18].

---

## 📋 Parameter Configuration

The environment extracts key hardware metadata parameters globally to scale the environment constraints:

| Parameter Macro | Default Value | Functional Role |
| :--- | :--- | :--- |
| `` `WIDTH `` | 8 bits | Determines individual data bus word width[cite: 6]. |
| `` `FIFO_SIZE `` | 16 slots | Total depth allocation inside the internal memory array block[cite: 6]. |
| `` `PTR_WIDTH `` | `$clog2(16) = 4` | Automatically derived pointer resolution size to index the memory[cite: 6]. |

---

## 🛠️ Simulation Execution

Run-time properties are driven using `$value$plusargs` parsing string hooks directly inside the initialization blocks, removing the need to recompile the test infrastructure for minor configuration adjustments[cite: 17].

```bash
# Example execution syntax inside common EDA simulators (e.g., Questasim/ModelSim)
vlog rtl/defines.sv rtl/fifo.v tb/*.sv
vsim top +Test_name=fifo_random_stress_test +N=100 -c -do "run -all; quit"
