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

If you utilize `beltopkit` in your research, please cite the associated publication (details to be updated upon publication).

-----

## License

Copyright (c) 2026 Yang Wang. All rights reserved.

This software is provided for **academic and non-commercial use only**. For commercial inquiries or licensing, please contact the author directly.

-----

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

% Executes the automated nomenclature and topology analysis demo
demo\_path\_codes()

For individual file analysis:

[pathcode, pathstring, rds, ringcell] = belt\_code('molecule.xyz');

-----

## 2\. Structural Generation & Construction

`beltopkit` provides tools to explore the configurational space of nanobelts and generate initial 3D molecular geometries for quantum chemical calculations.

### Möbius Topoisomer Enumeration

Automatically generate all nonequivalent Möbius topoisomers from a base CNB topology (e.g., [12,12] CNB or Octulene):

demo\_MCNBs\_CNB\_12\_12\_12235()
demo\_MCNBs\_octulene()

### 3D Geometry Generation

Transform topological path codes into 3D molecular coordinates (.xyz format) via an interactive menu:

% Launches the interactive construction menu
demo\_gen\_geom3d\_from\_pathcode()


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

