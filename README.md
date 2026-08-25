# popricinus
Population genomics of *Ixodes ricinus*, a major Palearctic vector of Lyme disease

## Overview
This repository contains the command-line workflows, and
configuration files used for the genomic and phylogenetic analyses
presented in **Genomic population of *Ixodes ricinus* reveals the presence of a genetic cline suggestive of climate adaptation**.

The analyses include sequence processing, variant filtering, population structure, phylogenetic, demographic, gene flow, and positive selection analyses, together with validation tests to assess potential sources of error and analytical biases.

## Repository structure

1. This section contains scripts and command-line workflows for short (s) and long reads (l):

- Quality control and read cleaning
-     Raw paired-end FASTQ files were quality-filtered and adapter-trimmed using fastp v0.23.4.
-     The script used for this step is: 01_sequence_processing/01_quality_control/01_fastp_quality_control.sh
- Reference genome preparation
- Read mapping
- Selection of high-quality sites
- File format conversion


│
├── 02_variant_filtering/
│
├── 03_structure_analyses/
│
├── 04_phylogenetic_analyses/
│
├── 05_demographic_analyses/
│
├── 06_gene_flow/
│
├── 07_positive_selection/
│
├── 08_validation_tests/
│
├── 09_figures/
│
├── metadata/
│
└── environment/
    ├── software_versions.txt
    └── R_sessionInfo.txt
## Data availability

### 01. Sequence processing


## Software and dependencies

## Analysis workflow

### 1. Data preprocessing
### 2. Phylogenetic analyses
### 3. Gene family analyses
### 4. Population/genomic analyses
### 5. Figure generation

## Reproducibility

## Citation

## Contact
