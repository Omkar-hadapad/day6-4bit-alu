# Day 6 — 4-Bit ALU

<p align="center">
  <b>4-Bit ALU RTL Design, Functional Verification & Cadence Genus Synthesis using Verilog HDL.</b>
</p>

<p align="center">
  <code>Specification → Architecture → RTL → Testbench → Simulation → Verification → Synthesis → Timing → Power → PPA → Documentation</code>
</p>

---

## 1. Project Information

| Item                     | Details                                                  |
| ------------------------ | -------------------------------------------------------- |
| Project                  | **Day 6**                                                |
| Design Title             | `4-Bit ALU`                                              |
| Top Module               | `alu_4bit`                                               |
| Domain                   | Digital VLSI / RTL Design                                |
| HDL                      | Verilog HDL                                              |
| Design Type              | Combinational Logic Circuit                              |
| Arithmetic Blocks        | `ADD_UNIT`, `SUB_UNIT`                                   |
| Addition Architecture    | 4-bit Ripple Carry Adder                                 |
| Subtraction Architecture | 4-bit Ripple Carry Adder                                 |
| Verification             | Functional verification performed in project environment |
| Simulation Tool          | Cadence NC-Sim                                           |
| Synthesis Tool           | Cadence Genus                                            |
| Genus Version            | `21.14-s082_1`                                           |
| Technology Library       | `tsmc18`                                                 |
| Operating Condition      | `slow (balanced_tree)`                                   |
| Wireload Mode            | `enclosed`                                               |
| Area Mode                | `timing library`                                         |
| Total Cell Count         | **98**                                                   |
| Sequential Cells         | **0 reported**                                           |
| Register Power           | **0 W**                                                  |
| Latch Power              | **0 W**                                                  |
| Total Cell Area          | **1473.595**                                             |
| Total Reported Power     | **48.9446 µW**                                           |
| Reported Data Path Delay | **2.267 ns**                                             |
| Reported Path            | **B[0] → COUT**                                          |
| Timing Status            | **UNCONSTRAINED**                                        |
| Project Status           | **Synthesis/PPA Analysis Complete**                      |

> **Note:** Verification counts, simulation completion time, exact ALU operation/control encoding, and constrained timing results are not included here unless supported by the corresponding project reports.

---

## 2. Project Overview

This project implements a **4-bit Arithmetic Logic Unit (ALU)** using synthesizable Verilog HDL.

The synthesized hierarchy supplied by Cadence Genus shows two explicit arithmetic units:

```text
                 alu_4bit
                    │
          ┌─────────┴─────────┐
          │                   │
      ADD_UNIT            SUB_UNIT
          │                   │
       4-bit RCA           4-bit RCA
```

The addition path contains a 4-bit ripple-carry adder, while the subtraction path contains a second 4-bit ripple-carry adder.

The supplied synthesis reports therefore provide direct evidence of the arithmetic hardware implemented inside the ALU.

---

## 3. Objective

The objectives of this project are:

* Understand the architecture of a small ALU.
* Integrate arithmetic datapath blocks into a top-level design.
* Understand hierarchical RTL design.
* Implement synthesizable Verilog RTL.
* Develop and execute functional verification.
* Understand the synthesized RTL hierarchy.
* Understand RTL-to-standard-cell technology mapping.
* Analyze standard-cell count.
* Analyze cell area.
* Analyze power components.
* Analyze the synthesized data path.
* Identify the reported longest data path.
* Understand ripple-carry timing behavior.
* Perform PPA analysis.
* Understand timing constraints and unconstrained paths.
* Document actual synthesis results.
* Build a professional Digital VLSI portfolio project.

---

## 4. ALU Concept

An Arithmetic Logic Unit is a combinational datapath block that performs selected arithmetic and/or logical operations according to control inputs.

Conceptually:

```text
                 A[3:0]
                    │
                    ▼
             ┌─────────────┐
             │             │
      B ────►│   4-Bit     │
             │    ALU      │
      Ctrl ─►│             │
             └──────┬──────┘
                    │
                    ▼
                Result
```

The supplied Genus hierarchy specifically identifies:

```text
ADD_UNIT
SUB_UNIT
```

as arithmetic sub-blocks.

The exact complete operation table and control encoding should be taken from the project's RTL/testbench rather than inferred from the synthesis hierarchy alone.

---

## 5. Hardware Architecture

The synthesized hierarchy gives the following structure:

```text
alu_4bit
│
├── ADD_UNIT
│   └── ADDER
│       └── ripple_carry_adder_4bit
│           ├── FA0
│           ├── FA1
│           ├── FA2
│           └── FA3
│
└── SUB_UNIT
    └── ADDER
        └── ripple_carry_adder_4bit_1
            ├── FA0
            ├── FA1
            ├── FA2
            └── FA3
```

Therefore, the supplied synthesis hierarchy demonstrates:

$$
\boxed{2 \times 4\text{-bit Ripple Carry Adders}}
$$

and:

$$
\boxed{8\text{ full-adder stages}}
$$

across the two arithmetic paths.

---

## 6. Block Diagram

```text
                         A[3:0]
                            │
                            │
                  ┌─────────┴─────────┐
                  │                   │
                  ▼                   ▼
             ┌─────────┐         ┌─────────┐
             │ADD_UNIT │         │SUB_UNIT │
             │  4-bit  │         │  4-bit  │
             │   RCA   │         │   RCA   │
             └────┬────┘         └────┬────┘
                  │                   │
                  │                   │
                  └─────────┬─────────┘
                            │
                            ▼
                       ALU Selection
                            │
                            ▼
                         Result
```

The exact selection/multiplexing structure should be taken from the synthesized gate-level report and project RTL.

---

## 7. Ripple Carry Adder Architecture

Each arithmetic block contains four full-adder stages.

```text
        FA0          FA1          FA2          FA3
     ┌───────┐    ┌───────┐    ┌───────┐    ┌───────┐
A0 ─►│       │    │       │    │       │    │       │◄─ A3
B0 ─►│  FA0  │─C1►│  FA1  │─C2►│  FA2  │─C3►│  FA3  │
Cin► │       │    │       │    │       │    │       │
     └───────┘    └───────┘    └───────┘    └───────┘
                                                     │
                                                     ▼
                                                    Cout
```

The carry dependency is:

$$
FA0 \rightarrow FA1 \rightarrow FA2 \rightarrow FA3
$$

This creates a serial carry-propagation path.

---

## 8. ADD_UNIT Hierarchy

The supplied Genus hierarchy reports:

```text
ADD_UNIT
└── ADDER
    └── ripple_carry_adder_4bit
        ├── FA0
        │   └── HA1
        │       ├── a1
        │       └── x1
        │
        ├── FA1
        │   ├── HA1
        │   │   ├── a1
        │   │   └── x1
        │   ├── HA2
        │   │   ├── a1
        │   │   └── x1
        │   └── O1
        │
        ├── FA2
        │   ├── HA1
        │   ├── HA2
        │   └── O1
        │
        └── FA3
            ├── HA1
            ├── HA2
            └── O1
```

The first full-adder stage is structurally different from the later stages in the reported hierarchy because of its input/carry conditions.

---

## 9. SUB_UNIT Hierarchy

The supplied Genus hierarchy reports:

```text
SUB_UNIT
└── ADDER
    └── ripple_carry_adder_4bit_1
        ├── FA0
        │   ├── HA1
        │   └── O1
        │
        ├── FA1
        │   ├── HA1
        │   ├── HA2
        │   └── O1
        │
        ├── FA2
        │   ├── HA1
        │   ├── HA2
        │   └── O1
        │
        └── FA3
            ├── HA1
            ├── HA2
            └── O1
```

This confirms the presence of a second four-stage ripple-carry arithmetic path.

---

## 10. RTL-to-Hardware Mapping

The supplied Genus technology-mapped report contains:

| Standard Cell | Instances |         Area |
| ------------- | --------: | -----------: |
| `AND2X1`      |        16 |      212.890 |
| `AOI21XL`     |         3 |       39.917 |
| `AOI221XL`    |         1 |       23.285 |
| `AOI222XL`    |         1 |       26.611 |
| `AOI22XL`     |         7 |      116.424 |
| `INVX1`       |         8 |       53.222 |
| `INVXL`       |         6 |       39.917 |
| `MXI2XL`      |         4 |       93.139 |
| `NAND2BXL`    |         2 |       26.611 |
| `NAND2XL`     |         5 |       49.896 |
| `NAND3BXL`    |         1 |       16.632 |
| `NAND3XL`     |         4 |       53.222 |
| `NAND4XL`     |         1 |       16.632 |
| `NOR2XL`      |         7 |       69.854 |
| `NOR3XL`      |         2 |       26.611 |
| `OAI21XL`     |         5 |       66.528 |
| `OAI221XL`    |         1 |       23.285 |
| `OAI222XL`    |         1 |       26.611 |
| `OR2X1`       |         9 |      119.750 |
| `XOR2XL`      |        14 |      372.557 |
| **Total**     |    **98** | **1473.595** |

This demonstrates that Genus transformed the RTL hierarchy into technology-specific standard-cell logic.

---

## 11. Standard-Cell Area Distribution

The largest individual standard-cell contributor in the supplied report is:

```text
XOR2XL
```

with:

```text
Instances = 14
Area      = 372.557
```

Its approximate contribution to total cell area is:

$$
\frac{372.557}{1473.595}\times100
\approx25.28\%
$$

Other major contributors include:

| Cell      |    Area | Approx. Contribution |
| --------- | ------: | -------------------: |
| `XOR2XL`  | 372.557 |               25.28% |
| `AND2X1`  | 212.890 |               14.45% |
| `OR2X1`   | 119.750 |                8.13% |
| `AOI22XL` | 116.424 |                7.90% |
| `MXI2XL`  |  93.139 |                6.32% |

The top five listed cell categories account for approximately:

$$
\boxed{62.1\%}
$$

of the reported total cell area.

---

## 12. Area Analysis

The supplied Genus hierarchy/area report gives:

| Metric           |       Result |
| ---------------- | -----------: |
| Top Module       |   `alu_4bit` |
| Total Cell Count |       **98** |
| Total Cell Area  | **1473.595** |
| Net Area         |    **0.000** |
| Total Area       | **1473.595** |

Therefore:

$$
\boxed{\text{Total Cell Area}=1473.595}
$$

The area value is retained in the **Genus/library area units reported by the tool**. No unsupported conversion to µm² is made.

---

## 13. Hierarchical Area Analysis

The supplied hierarchy report gives:

| Module     | Cells |         Area |
| ---------- | ----: | -----------: |
| `alu_4bit` |    98 | **1473.595** |
| `ADD_UNIT` |    17 |  **319.334** |
| `SUB_UNIT` |    23 |  **365.904** |

The combined reported area of the two arithmetic sub-blocks is:

$$
319.334+365.904=685.238
$$

Therefore:

$$
\boxed{685.238}
$$

is the combined reported area of `ADD_UNIT` and `SUB_UNIT`.

Relative to the top-level area:

$$
\frac{685.238}{1473.595}\times100
\approx46.5\%
$$

Thus, approximately **46.5% of the reported top-level cell area is associated with these two arithmetic hierarchy blocks**, based on the supplied hierarchy report.

---

## 14. Power Analysis

The supplied Genus power report gives:

```text
Instance: /alu_4bit
Power Unit: W
PDB Frame: /stim#0/frame#0
```

### Total Power

$$
P_{total}=4.89446\times10^{-5}W
$$

Therefore:

$$
\boxed{P_{total}=48.9446\ \mu W}
$$

---

## 15. Power Breakdown

| Category  |     Power (W) |  Power (µW) | Contribution |
| --------- | ------------: | ----------: | -----------: |
| Leakage   | `5.15179e-08` |  **0.0515** |    **0.11%** |
| Internal  | `2.96078e-05` | **29.6078** |   **60.49%** |
| Switching | `1.92853e-05` | **19.2853** |   **39.40%** |
| **Total** | `4.89446e-05` | **48.9446** |     **100%** |

The dominant reported power component is:

$$
\boxed{\text{Internal Power}=60.49\%}
$$

followed by:

$$
\boxed{\text{Switching Power}=39.40\%}
$$

and:

$$
\boxed{\text{Leakage Power}=0.11\%}
$$

---

## 16. Power Category Analysis

The power report attributes all reported power to:

```text
logic
```

The following categories report zero power:

```text
memory
register
latch
bbox
clock
pad
pm
```

Therefore:

$$
\boxed{\text{Logic Power}=100\%}
$$

This is consistent with the supplied report showing no register or latch power.

---

## 17. Power Interpretation

The reported power is associated with:

```text
PDB Frame:
/stim#0/frame#0
```

Therefore, the value:

```text
48.9446 µW
```

should be interpreted as the power reported for the supplied power-analysis configuration and stimulus frame.

It should not be presented as a universal power value for every possible ALU workload.

---

## 18. Timing Analysis

The supplied Genus timing report identifies:

```text
Path 1: UNCONSTRAINED

Startpoint: (F) B[0]
Endpoint:   (F) COUT

Data Path: 2267 ps
```

Therefore:

$$
\boxed{T_{path}=2267\ ps}
$$

or:

$$
\boxed{T_{path}=2.267\ ns}
$$

### Reported Path

```text
B[0]
 │
 ▼
INVXL
 │
 ▼
XOR2XL
 │
 ▼
OR2X1
 │
 ▼
AND2X1
 │
 ▼
OR2X1
 │
 ▼
AND2X1
 │
 ▼
OR2X1
 │
 ▼
AND2X1
 │
 ▼
OR2X1
 │
 ▼
AOI22XL
 │
 ▼
NAND3XL
 │
 ▼
COUT
```

---

## 19. Timing Path Breakdown

| Timing Point                            | Cell      |  Delay |     Arrival |
| --------------------------------------- | --------- | -----: | ----------: |
| `B[0]`                                  | Input     |   0 ps |        0 ps |
| `SUB_UNIT/g12/Y`                        | `INVXL`   |  66 ps |       66 ps |
| `SUB_UNIT/ADDER/FA0/HA1/x1/g13__4733/Y` | `XOR2XL`  | 363 ps |      430 ps |
| `SUB_UNIT/ADDER/FA0/O1/g2__6161/Y`      | `OR2X1`   | 242 ps |      672 ps |
| `SUB_UNIT/ADDER/FA1/HA2/a1/g11__2883/Y` | `AND2X1`  | 192 ps |      864 ps |
| `SUB_UNIT/ADDER/FA1/O1/g2__1666/Y`      | `OR2X1`   | 229 ps |     1092 ps |
| `SUB_UNIT/ADDER/FA2/HA2/a1/g11__5477/Y` | `AND2X1`  | 192 ps |     1284 ps |
| `SUB_UNIT/ADDER/FA2/O1/g2__5107/Y`      | `OR2X1`   | 229 ps |     1513 ps |
| `SUB_UNIT/ADDER/FA3/HA2/a1/g11__8428/Y` | `AND2X1`  | 192 ps |     1705 ps |
| `SUB_UNIT/ADDER/FA3/O1/g2__6783/Y`      | `OR2X1`   | 224 ps |     1929 ps |
| `g1393__3680/Y`                         | `AOI22XL` | 244 ps |     2173 ps |
| `g1370__7098/Y`                         | `NAND3XL` |  94 ps | **2267 ps** |
| `COUT`                                  | Output    |   0 ps | **2267 ps** |

---

## 20. Timing Interpretation

The reported path travels through the subtraction unit:

```text
SUB_UNIT
   ↓
FA0
   ↓
FA1
   ↓
FA2
   ↓
FA3
   ↓
COUT logic
```

This is consistent with the ripple-carry structure reported in the hierarchy.

The carry dependency of an RCA creates a serial logic path:

```text
FA0 → FA1 → FA2 → FA3
```

Therefore, the reported path provides actual synthesis evidence that the ripple-carry structure contributes to the observed data-path delay.

---

## 21. Largest Individual Cell Delay

From the supplied path:

| Cell      |      Delay |
| --------- | ---------: |
| `XOR2XL`  | **363 ps** |
| `AOI22XL` | **244 ps** |
| `OR2X1`   | **242 ps** |
| `OR2X1`   | **229 ps** |
| `OR2X1`   | **229 ps** |
| `OR2X1`   | **224 ps** |
| `AND2X1`  | **192 ps** |
| `AND2X1`  | **192 ps** |
| `AND2X1`  | **192 ps** |
| `NAND3XL` |      94 ps |
| `INVXL`   |      66 ps |

The largest individual cell delay is:

$$
\boxed{363\ ps\text{ from XOR2XL}}
$$

However, the total path delay is the accumulated delay of the complete logic chain.

---

## 22. Timing Constraint Limitation

The supplied Genus report explicitly states:

```text
Path 1: UNCONSTRAINED
```

Therefore, this report does **not** establish:

* Timing closure
* Setup slack
* Hold slack
* Required time
* Clock-period compliance
* Guaranteed maximum operating frequency

The correct statement is:

> The synthesized `B[0] → COUT` path has a reported data-path delay of **2.267 ns**. The path is **unconstrained**, so this value is documented as a raw synthesized data-path delay rather than a constrained timing-closure result.

---

## 23. PPA Summary

PPA represents:

```text
Power
Performance
Area
```

### Actual Day-6 Results

| PPA Metric                   |     Actual Result |
| ---------------------------- | ----------------: |
| **Total Cell Area**          |      **1473.595** |
| **Total Cell Count**         |            **98** |
| **Total Power**              |    **48.9446 µW** |
| **Internal Power**           |    **29.6078 µW** |
| **Switching Power**          |    **19.2853 µW** |
| **Leakage Power**            |     **0.0515 µW** |
| **Reported Data Path Delay** |      **2.267 ns** |
| **Reported Path**            |   **B[0] → COUT** |
| **Timing Status**            | **UNCONSTRAINED** |
| **Sequential/Clock Power**   |  **0 W reported** |

---

## 24. PPA Representation

```text
┌────────────────────────────────────────────┐
│           DAY 6 — PPA RESULTS              │
├────────────────────────────────────────────┤
│ Area        : 1473.595                     │
│ Cells       : 98                           │
│ Power       : 48.9446 µW                   │
│ Internal    : 29.6078 µW                   │
│ Switching   : 19.2853 µW                   │
│ Leakage     : 0.0515 µW                    │
│ Delay       : 2.267 ns                     │
│ Path        : B[0] → COUT                  │
│ Timing      : UNCONSTRAINED                │
└────────────────────────────────────────────┘
```

---

## 25. Architecture Trade-Off

The supplied design uses separate arithmetic blocks:

```text
ADD_UNIT
    +
SUB_UNIT
```

This provides separate arithmetic datapaths, but it also contributes to hardware resources.

The supplied synthesis result contains:

```text
98 standard-cell instances
```

and:

```text
1473.595 total cell area
```

A possible future architecture could investigate arithmetic-resource sharing, but such an optimization should only be claimed after implementing and synthesizing an alternative design.

The correct engineering comparison is:

```text
Architecture A
      ↓
Synthesis
      ↓
Area / Timing / Power

Architecture B
      ↓
Synthesis
      ↓
Area / Timing / Power

          ↓
     Compare PPA
```

No optimization improvement is claimed until an alternative implementation has actual synthesis results.

---

## 26. Optimization Considerations

Potential optimization directions for this ALU include:

### 1. Arithmetic Resource Sharing

Investigate whether addition and subtraction can share arithmetic hardware.

**Potential benefit:**

```text
Area ↓
```

**Possible trade-off:**

```text
MUX/control logic ↑
Timing may change
Power may change
```

### 2. Carry Architecture

The current arithmetic hierarchy uses ripple-carry structures.

Alternative architectures could include:

```text
Ripple Carry
Carry Look-Ahead
Carry Select
Carry Skip
```

The choice involves:

```text
Area ↔ Delay ↔ Power
```

### 3. Logic Depth

The reported path contains multiple cascaded logic stages.

Reducing logic depth may improve timing, but the actual effect must be verified through synthesis.

### 4. Technology Mapping

Equivalent RTL Boolean expressions may map to different standard-cell structures.

### 5. MUX Optimization

If the complete ALU contains multiple selectable operations, the operation-selection network can become a significant contributor to:

```text
Area
Delay
Switching power
```

The exact effect should be determined from the actual RTL and synthesis reports.

---

## 27. Verification

The Day-6 project includes a functional verification environment, but the reports supplied for this README do not provide a complete numerical verification summary.

Therefore, no unsupported value such as:

```text
24/24 PASS
100% PASS
N/N PASS
```

is claimed here.

Recommended verification structure:

```text
ALU Inputs
    │
    ▼
Operation Selection
    │
    ▼
Expected Result
    │
    ├──────────────┐
    ▼              ▼
Reference        DUT
    │              │
    └──── Compare ─┘
           │
           ▼
        PASS/FAIL
```

The actual verification count should be added from the final NC-Sim/testbench report.

---

## 28. Simulation

The project uses Cadence NC-Sim for simulation.

The simulation environment should verify:

* Arithmetic operations
* Control/operation selection
* Boundary values
* Zero values
* Maximum 4-bit values
* Carry generation
* Subtraction behavior
* Result correctness
* Output selection

The exact simulation completion time and final test count are not included in the supplied Day-6 synthesis reports.

---

## 29. Synthesis Flow

The design was synthesized using Cadence Genus.

```text
Verilog RTL
     ↓
Read / Elaborate
     ↓
Hierarchy
     ↓
Logic Synthesis
     ↓
Boolean Optimization
     ↓
Technology Mapping
     ↓
Standard-Cell Netlist
     ↓
Area Analysis
     ↓
Timing Analysis
     ↓
Power Analysis
     ↓
PPA Analysis
```

### Genus Configuration

| Parameter           | Actual Value           |
| ------------------- | ---------------------- |
| Tool                | Cadence Genus          |
| Version             | `21.14-s082_1`         |
| Top Module          | `alu_4bit`             |
| Technology Library  | `tsmc18`               |
| Operating Condition | `slow (balanced_tree)` |
| Wireload Mode       | `enclosed`             |
| Area Mode           | `timing library`       |
| Report Date         | Sep 30, 2026           |

---

## 30. Hierarchical Synthesis Summary

The supplied hierarchy report confirms:

```text
alu_4bit
│
├── ADD_UNIT
│   └── adder_subtractor_4bit
│       └── ripple_carry_adder_4bit
│
└── SUB_UNIT
    └── adder_subtractor_4bit_1
        └── ripple_carry_adder_4bit_1
```

The arithmetic blocks contain:

```text
ADD_UNIT → 4 full-adder stages
SUB_UNIT → 4 full-adder stages
```

Total:

$$
\boxed{8\text{ full-adder stages}}
$$

---

## 31. Hardware Interpretation

### What hardware does this RTL create?

Based on the supplied synthesis reports:

```text
Top-level ALU
      │
      ├── ADD arithmetic datapath
      │       └── 4-bit RCA
      │            └── 4 FA stages
      │
      └── SUB arithmetic datapath
              └── 4-bit RCA
                   └── 4 FA stages
```

The technology-mapped implementation contains:

```text
98 standard-cell instances
```

including:

```text
XOR
AND
OR
NAND
NOR
AOI
OAI
MUX-related cells
INV
```

The actual final hardware is therefore determined by the **technology-mapped standard-cell netlist**, not simply by the RTL module names.

---

## 32. Common Design Mistakes

### 1. Treating the ALU as only an RTL coding problem

The important question is:

> What datapath and control hardware does the RTL infer?

### 2. Ignoring carry propagation

Ripple-carry arithmetic creates a serial carry dependency.

```text
FA0 → FA1 → FA2 → FA3
```

### 3. Ignoring width

For a 4-bit arithmetic design, result width and carry behavior must be explicitly considered.

### 4. Ignoring subtraction behavior

Subtraction may involve borrow/carry conventions depending on the implementation.

### 5. Multiple drivers

Each output should have a well-defined driving source.

### 6. Incomplete combinational assignments

Incomplete assignments can infer unintended latches.

### 7. Incorrect operation selection

ALU control logic must select the intended datapath result.

### 8. Assuming RTL hierarchy equals standard-cell hierarchy

Genus can optimize and restructure logic during synthesis.

### 9. Treating unconstrained timing as timing closure

```text
UNCONSTRAINED
```

does not mean the design has passed timing constraints.

### 10. Treating simulation success as PPA success

Functional correctness, area, power, and timing are separate engineering objectives.

---

## 33. Verification and Synthesis Status

| Item                    | Status                                             |
| ----------------------- | -------------------------------------------------- |
| ALU RTL                 | **Implemented**                                    |
| Functional Verification | **Performed; numerical summary not supplied here** |
| Simulation              | **Performed**                                      |
| Genus Synthesis         | **Complete**                                       |
| Hierarchy Analysis      | **Complete**                                       |
| Technology Mapping      | **Complete**                                       |
| Area Analysis           | **Complete**                                       |
| Power Analysis          | **Complete**                                       |
| Timing Path Analysis    | **Complete**                                       |
| PPA Analysis            | **Complete**                                       |
| Timing Closure          | **Not claimed**                                    |
| Constrained Timing      | **Not available in supplied report**               |
| Optimization Comparison | **Not yet performed**                              |

---

## 34. Evidence-Based Results

### Area

```text
Total Cells = 98
Total Area  = 1473.595
```

### Power

```text
Total       = 48.9446 µW
Internal    = 29.6078 µW
Switching   = 19.2853 µW
Leakage     = 0.0515 µW
```

### Timing

```text
Path        = B[0] → COUT
Delay       = 2.267 ns
Status      = UNCONSTRAINED
```

### Architecture

```text
ADD_UNIT → 4-bit RCA
SUB_UNIT → 4-bit RCA
```

### Arithmetic Hardware

```text
8 full-adder stages across the two arithmetic units
```

---

## 35. Industry Relevance

A 4-bit ALU is a fundamental datapath building block used in:

* CPUs
* Microcontrollers
* DSP datapaths
* Embedded processors
* Control processors
* ASIC datapaths
* FPGA datapaths
* Arithmetic units
* SoC designs
* RISC-V processor datapaths

### Skills Demonstrated

```text
Digital Logic Design
        ↓
Verilog RTL
        ↓
Hierarchical RTL
        ↓
Datapath Design
        ↓
Functional Verification
        ↓
NC-Sim Simulation
        ↓
Cadence Genus
        ↓
Technology Mapping
        ↓
Area Analysis
        ↓
Timing Analysis
        ↓
Power Analysis
        ↓
PPA Analysis
        ↓
Engineering Documentation
```

---

## 36. GATE Relevance

Important concepts reinforced by this project include:

* Arithmetic circuits
* Full adders
* Ripple-carry adders
* Carry propagation
* Boolean logic
* Multiplexers
* Combinational circuits
* Propagation delay
* Logic depth
* Area-delay trade-offs
* Power components
* Standard-cell implementation

### Ripple-Carry Principle

For an N-bit ripple-carry adder:

```text
FA0 → FA1 → FA2 → ... → FA(N-1)
```

The carry generated by one stage becomes an input to the next stage.

For this project:

$$
\boxed{FA0\rightarrow FA1\rightarrow FA2\rightarrow FA3}
$$

---

## 37. Interview Questions

### Basic Questions

**Q1. What is an ALU?**

An Arithmetic Logic Unit is a combinational datapath block that performs selected arithmetic and/or logical operations.

**Q2. What arithmetic structures are present in your synthesized ALU?**

The supplied Genus hierarchy shows separate `ADD_UNIT` and `SUB_UNIT` blocks, each containing a 4-bit ripple-carry adder.

**Q3. How many full-adder stages are present across these two arithmetic units?**

```text
4 + 4 = 8 full-adder stages
```

---

### RTL Questions

**Q4. What hardware does your ALU RTL create?**

The supplied synthesis reports show a top-level ALU containing separate addition and subtraction arithmetic datapaths, mapped to 98 standard-cell instances.

**Q5. Why can RTL hierarchy differ from the final standard-cell hierarchy?**

Because synthesis performs Boolean optimization, restructuring, and technology mapping.

**Q6. Why is combinational completeness important in an ALU?**

Incomplete assignments in combinational RTL can infer unintended storage elements such as latches.

---

### Debugging Questions

**Q7. What would you check if the ALU result is incorrect only for subtraction?**

Check subtraction control, operand transformation, carry/borrow handling, result width, and the subtraction testbench vectors.

**Q8. What would you check if only certain operation selections fail?**

Check the operation-selection/control logic and whether each selected result is correctly assigned.

---

### Hardware Questions

**Q9. What is the timing disadvantage of a ripple-carry adder?**

Carry propagation passes through multiple arithmetic stages, creating a potentially long combinational path.

**Q10. Why is `B[0] → COUT` important in your synthesis report?**

It is the reported longest data path in the supplied timing report and has a delay of **2.267 ns**.

---

### Advanced Questions

**Q11. How could you improve the arithmetic timing?**

Investigate faster carry architectures such as carry-lookahead or carry-select structures, then compare actual area, timing, and power results.

**Q12. How could you reduce ALU area?**

Investigate resource sharing and optimized operation-selection architecture, while measuring the resulting timing and power trade-offs.

---

## 38. Tiny Memory

### TINY MEMORY

* **ALU** → datapath + operation selection.
* **RCA** → carry propagates from one full adder to the next.
* **Day-6 arithmetic hierarchy** → 2 × 4-bit RCA.
* **Total arithmetic stages** → 8 full adders.
* **Reported area** → 1473.595.
* **Reported power** → 48.9446 µW.
* **Reported delay** → 2.267 ns.
* **UNCONSTRAINED** → do not claim timing closure or validated Fmax.

---

## 39. Project Limitations

The supplied synthesis/timing reports have several limitations that should remain explicit in the documentation:

1. The reported timing path is **unconstrained**.
2. No setup/hold slack is supplied.
3. No clock constraint is supplied.
4. No validated maximum operating frequency is supplied.
5. The supplied reports do not provide a complete verification count.
6. No formal verification result is supplied.
7. No constrained-random verification result is supplied.
8. No functional coverage percentage is supplied.
9. No alternative architecture PPA comparison has been performed.

These are documentation limitations, not failures of the ALU itself.

---

## 40. Future Improvements

Potential future work:

```text
Current ALU
    │
    ├── Constrain timing
    │
    ├── Generate complete timing summary
    │
    ├── Verify all ALU operations
    │
    ├── Add stronger self-checking testbench
    │
    ├── Investigate arithmetic resource sharing
    │
    ├── Compare RCA with faster carry architecture
    │
    ├── Optimize operation-selection logic
    │
    └── Compare PPA
```

Future architecture comparisons should use actual synthesis results rather than theoretical claims.

---

## 41. Recommended Repository Structure

```text
day6-4bit-alu/
│
├── README.md
│
├── rtl/
│   ├── alu_4bit.v
│   ├── adder_subtractor_4bit.v
│   ├── ripple_carry_adder_4bit.v
│   └── full_adder.v
│
├── tb/
│   └── day6_tb.v
│
├── simulation/
│   ├── console_output.txt
│   └── waves.shm/
│
├── synthesis/
│   ├── genus.tcl
│   └── netlist/
│
├── timing/
│   └── timing_path_report.txt
│
├── power/
│   └── power_report.txt
│
├── reports/
│   ├── area_report.txt
│   ├── hierarchy_report.txt
│   ├── cell_area_report.txt
│   ├── power_report.txt
│   └── timing_path_report.txt
│
├── images/
│   ├── verification_console.png
│   ├── waveform.png
│   ├── hierarchy_report.png
│   ├── cell_area_report.png
│   ├── power_report.png
│   └── timing_path.png
│
└── docs/
    └── project_report.pdf
```

---

## 42. Project Evidence

Recommended evidence files:

```text
reports/
├── hierarchy_report.txt
├── area_report.txt
├── cell_area_report.txt
├── power_report.txt
└── timing_path_report.txt
```

Recommended screenshots:

```text
images/
├── rtl_simulation.png
├── waveform.png
├── genus_hierarchy.png
├── genus_area.png
├── genus_cell_area.png
├── genus_power.png
└── genus_timing.png
```

Only screenshots and reports actually generated from the project should be committed.

---

## 43. Learning Outcome

```text
ALU Specification
        ↓
Architecture
        ↓
Arithmetic Datapath
        ↓
RTL
        ↓
Testbench
        ↓
Simulation
        ↓
Functional Verification
        ↓
Cadence Genus
        ↓
Hierarchy Analysis
        ↓
Technology Mapping
        ↓
Area Analysis
        ↓
Timing Analysis
        ↓
Power Analysis
        ↓
PPA
        ↓
Optimization
        ↓
Documentation
```

### Core Engineering Question

> **What hardware does this RTL create?**

### Answer

The supplied Genus reports show that the `alu_4bit` RTL synthesizes into a **98-cell combinational standard-cell implementation**, with separate `ADD_UNIT` and `SUB_UNIT` arithmetic blocks. Each arithmetic block contains a **4-bit ripple-carry adder**, giving **8 full-adder stages across the two arithmetic paths**.

The synthesized design has a reported cell area of **1473.595**, total reported power of **48.9446 µW**, and a reported `B[0] → COUT` data-path delay of **2.267 ns**.

---

## 44. Final Day-6 Results

```text
┌──────────────────────────────────────────────┐
│            DAY 6 — 4-BIT ALU                │
├──────────────────────────────────────────────┤
│ Top Module       : alu_4bit                  │
│ Technology       : tsmc18                    │
│ Leaf Cells       : 98                        │
│ Total Area       : 1473.595                  │
│ Total Power      : 48.9446 µW                │
│ Internal Power   : 29.6078 µW                │
│ Switching Power  : 19.2853 µW                │
│ Leakage Power    : 0.0515 µW                 │
│ Delay            : 2.267 ns                  │
│ Reported Path    : B[0] → COUT              │
│ Timing Status    : UNCONSTRAINED             │
│ ADD Unit         : 4-bit RCA                 │
│ SUB Unit         : 4-bit RCA                 │
│ Full Adders      : 8 across both paths       │
│ Project Status   : PPA ANALYSIS COMPLETE     │
└──────────────────────────────────────────────┘
```

---

## 45. Evidence-Based Conclusion

The Day-6 4-bit ALU was synthesized using **Cadence Genus 21.14-s082_1** with the `tsmc18` technology library under the `slow (balanced_tree)` operating condition.

The supplied synthesis hierarchy identifies separate `ADD_UNIT` and `SUB_UNIT` blocks, each containing a 4-bit ripple-carry adder. This corresponds to **eight full-adder stages across the two arithmetic datapaths**.

Genus reports:

```text
98 standard-cell instances
1473.595 total cell area
48.9446 µW total reported power
2.267 ns B[0] → COUT data-path delay
```

The power breakdown is:

```text
Internal  : 60.49%
Switching : 39.40%
Leakage   :  0.11%
```

The reported timing path is explicitly:

```text
UNCONSTRAINED
```

Therefore, the **2.267 ns value is documented as a synthesized data-path delay**, and no timing-closure, setup/hold, or maximum-frequency claim is made.

The project therefore demonstrates the complete available synthesis/PPA analysis from the supplied evidence:

```text
RTL
 ↓
Hierarchy
 ↓
Technology Mapping
 ↓
Area
 ↓
Power
 ↓
Timing Path
 ↓
PPA
```

---

## Author

**Omkar Kalmesh Hadapad**

B.E. Electronics & Communication Engineering
SDM Institute of Technology, Ujire, Karnataka

### Focus Areas

```text
Digital VLSI
RTL Design
Verilog / SystemVerilog
ASIC Design
Design Verification
Cadence Genus
Cadence Innovus
Digital Logic
PPA Analysis
```

### Day 6

**4-Bit ALU — RTL → Simulation → Verification → Genus Synthesis → Timing → Power → PPA → Documentation**

**Next: Day 7 — D Flip-Flop with Reset & Enable**
