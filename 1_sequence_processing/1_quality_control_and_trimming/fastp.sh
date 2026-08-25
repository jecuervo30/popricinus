#!/bin/bash

# ============================================================
# Quality control and read cleaning *s* using fastp
# ============================================================

# Load software
module load bio/fastp/0.23.4

# Paths
INPUT_DIR="/HOME/1-RAW/PATH"
OUTPUT_DIR="/HOME/2-TRIMMED/PATH"
REPORT_DIR="/HOME/2-TRIMMED/PATH"

mkdir -p "$OUTPUT_DIR" "$REPORT_DIR"

# Loop over R1 FASTQ files
for file in "$INPUT_DIR"/*_R1_001.fastq.gz; do

    [ -e "$file" ] || {
        echo "No input files found in $INPUT_DIR"
        break
    }

    sample=$(basename "$file" "_R1_001.fastq.gz")

    echo "+ Trimming sample: $sample"

    fastp -w 4 -g -x -c -n 5 -l 30 --detect_adapter_for_pe \
        -i "${INPUT_DIR}/${sample}_R1_001.fastq.gz" \
        -I "${INPUT_DIR}/${sample}_R2_001.fastq.gz" \
        -o "${OUTPUT_DIR}/${sample}_trimmed_R1.fq.gz" \
        -O "${OUTPUT_DIR}/${sample}_trimmed_R2.fq.gz" \
        -h "${REPORT_DIR}/${sample}_fastp_report.html" \
        -j "${REPORT_DIR}/${sample}_fastp_report.json"

    echo "+ Generated: ${OUTPUT_DIR}/${sample}_trimmed_R1.fq.gz"
    echo "+ Generated: ${OUTPUT_DIR}/${sample}_trimmed_R2.fq.gz"

done
