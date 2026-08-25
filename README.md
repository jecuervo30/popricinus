# popricinus
Population genomics of *Ixodes ricinus*, a major Palearctic vector of Lyme disease

## OVERVIEW
This repository contains the command-line workflows, and
configuration files used for the genomic and phylogenetic analyses
presented in **Genomic population of *Ixodes ricinus* reveals the presence of a genetic cline suggestive of climate adaptation**.

The analyses include sequence processing, variant filtering, population structure, phylogenetic, demographic, gene flow, and positive selection analyses, together with validation tests to assess potential sources of error and analytical biases.

## REPOSITORY STRUCTURE

This section contains scripts and command-line workflows for short (s) and long reads (l):

# 1. Sequence processing

a.    Quality control and read cleaning
Raw paired-end FASTQ files were quality-filtered and adapter-trimmed using fastp and fastplong.
The script used for this step is:
 

- **Short reads:** [s-fastp.sh](1_sequence_processing/1a_quality_control_and_trimming/s-fastp.sh)
- **Long reads:** [l-fastplong.sh](1_sequence_processing/1a_quality_control_and_trimming/l-fastplong.sh)

b.    Reference genome preparation


c.    Read mapping
d.    Selection of high-quality sites
e.    File format conversion

# 2. Variant filtering



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
