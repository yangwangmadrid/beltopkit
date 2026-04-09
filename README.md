-----

# beltopkit

**A Topology-Based Toolkit for Generalized Carbon Nanobelts**

`beltopkit` is a specialized MATLAB package of source codes designed for the topological analysis and structural construction of generalized Carbon Nanobelts (CNBs). The toolkit supports a wide variety of molecular architectures, including untwisted, singly, and multiply twisted structures with both Hückel and Möbius topologies.

-----

## Contact & Attribution

**Author**: Yang Wang
**Institution**: Yangzhou University
**Email**: yangwang@yzu.edu.cn
**ORCID**: [0000-0003-2540-2199](https://orcid.org/0000-0003-2540-2199)

If you utilize `beltopkit` in your research, please cite the associated preprint/publication:
- Y. Wang. A Unified Topological Framework for Representation and Construction of Generalized Carbon Nanobelts *ChemRxiv* **2026**, preprint: [DOI:10.26434/chemrxiv.15001591/v1](https://doi.org/10.26434/chemrxiv.15001591/v1)

-----

## Installation

1. Clone or download this repository to your local machine.

2. Launch MATLAB.

3. Add the `beltopkit` directory and its subfolders to your MATLAB path:
```matlab
% Run this in the MATLAB Command Window
addpath(genpath('/path/to/beltopkit'))
savepath
```

-----

## Quick Start

### 1. Topology Analysis and Nomenclature

To analyze the topological characteristics (path codes, RDS, Hückel/Möbius status, etc.) of representative generalized CNBs:

- Navigate to the demo/nomenclature/ directory within MATLAB.

- Run the following script:
```matlab
demo_path_codes
```
- Detailed topological data and symmetry information will be printed directly to the Command Window.


### 2. Structural Enumeration and 3D Construction
To explore the configurational space and generate 3D coordinates:

- Navigate to the demo/construction/ directory.

- **Möbius Topoisomer Enumeration:** Run these scripts to generate nonequivalent Möbius CNBs from various parent molecules:
```matlab
demo_MCNBs_CNB_12_12_12235   % From parent CNB (12,12)-12235
demo_MCNBs_octulene          % From Octulene
demo_MCNBs_expKek45          % From expanded [4,5]kekulene
```
- Interactive 3D Geometry Generation: To generate .xyz coordinates from specific topological path codes:
```matlab
demo_gen_geom3d_from_pathcode
```
*This script covers untwisted, singly, doubly, and triply twisted belts.*

-----

<br>

## 1\. Topology Analysis & Nomenclature

`beltopkit` outputs the topological characteristics of a given generalized CNB from its 3D atomic coordinates in an input xyz file or Gaussian output file.

### Core Outputs

  * **Path Code**
  * **Path String**
  * **Ring Directional Sequence (RDS)**
  * **Rings with the corresponding Indices of Atoms

### Supported Systems

The toolkit is validated against a wide range of theoretically significant and experimentally synthesized generalized CNBs, including untwisted, singly, and multiply twisted structures with both Hückel and Möbius topologies.


### Usage Example

To perform batch demo on existing .xyz geometries and extract their topological parameters:
```matlab
% Executes the automated nomenclature and topology analysis demo
demo_path_codes()
```

For individual file analysis:
```matlab
[pathcode, pathstring, rds, ringcell] = belt_code('molecule.xyz');
```

-----

## 2\. Structural Generation & Construction

`beltopkit` provides tools to explore the configurational space of nanobelts and generate initial 3D molecular geometries for quantum chemical calculations.

### Möbius Topoisomer Enumeration

Automatically generate all nonequivalent Möbius topoisomers from a base CNB topology (e.g., [12,12] CNB or Octulene):
```matlab
demo_MCNBs_CNB_12_12_12235()
demo_MCNBs_octulene()
```

### 3D Geometry Generation

Transform topological path codes into 3D molecular coordinates (.xyz format) via an interactive menu:
```matlab
% Launches the interactive construction menu
demo_gen_geom3d_from_pathcode()
```

-----

## Technical Implementation & Verification

The toolkit includes a "round-trip" verification protocol that re-calculates path codes from generated geometries to ensure absolute structural integrity.

### Directory Structure and Key Scripts

  * beltopkit/: Root directory of `beltopkit`, containing all functioning codes
  * beltopkit/demo/nomenclature/: Demostration scripts for nomenclature &
    topology analysis
  * beltopkit/demo/construction/: Demostration scripts for 3D structural 
    generation and topoisomer enumeration.

  * **belt\_code.m**: Core engine for topology analysis and nomenclature.
  * **gen\_belt\_from\_pathcode.m**: Core engine for 3D coordinate generation.
  * **genMCNBs\_from\_CNB\_topo.m**: For Möbius topoisomer enumeration.
  * **decode\_belt\_code.m**: Parser for topological string descriptors.
  * **write\_xyz.m**: Utility to export molecular data to standard .xyz format.

-----

## License

Copyright (c) 2026 Yang Wang. All rights reserved.

This software is provided for **academic and non-commercial use only**. For commercial inquiries or licensing, please contact the author directly.

-----

