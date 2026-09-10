**Dual-Port RAM UVM Verification**

Overview

This project demonstrates the functional verification of a Dual-Port RAM using SystemVerilog and UVM.

The verification environment is designed to verify read and write operations through independent read and write ports. 
A UVM-based self-checking testbench is used to generate transactions, monitor DUT activity, compare expected and actual results, and measure functional coverage.

Note: The RTL/DUT source code is proprietary material and is intentionally not included in this repository.

**Verification Environment**

<img width="391" height="384" alt="image" src="https://github.com/user-attachments/assets/7c92d789-46ec-42f1-9aea-3ca016fd6fb3" />

UVM Components
Write Agent

The write agent generates and drives write transactions to the DUT.

It contains:

Write Sequencer
Write Driver
Write Monitor
Write Agent Configuration
Read Agent

The read agent generates and monitors read transactions.

It contains:

Read Sequencer
Read Driver
Read Monitor
Read Agent Configuration
Virtual Sequencer

The virtual sequencer coordinates the write and read sequencers and allows multiple agents to be controlled from a single virtual sequence.


Scoreboard

The scoreboard provides self-checking functionality.

It contains:

Write transaction FIFO
Read transaction FIFO
Reference memory model
Data comparison logic
Scoreboard statistics
Functional coverage


Reference Model

An associative array is used as the memory reference model:

logic [63:0] ref_data [bit [31:0]];

The reference model stores the expected data during write operations.

During a read operation, the expected data is retrieved from the reference model and compared with the data received from the DUT.
<img width="397" height="174" alt="image" src="https://github.com/user-attachments/assets/5f11b38c-cbc7-444a-9b5e-b2d4a05584d5" />

Test Scenarios

The verification environment includes different transaction scenarios:

1. Single Address

Verifies basic read and write operations at a single address.

2. Ten Addresses

Performs read/write operations across multiple addresses.

3. Even Address

Verifies transactions targeting even addresses.

4. Odd Address

Verifies transactions targeting odd addresses.

Tools Used: 
SystemVerilog, UVM
QuestaSim / ModelSim / Synopsys VCS / Linux
FSDB waveform dumping for VCS
