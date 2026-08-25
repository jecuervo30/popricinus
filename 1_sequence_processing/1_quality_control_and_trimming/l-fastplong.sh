#!/bin/bash

# ============================================================
# Quality control and read cleaning of long reads
# ============================================================
#
# Software:
#   fastplong
#
# Input:
#   Raw long-read FASTQ files (.gz)
#
# Output:
#   Quality-filtered and trimmed long-read FASTQ files
#
# Parameters:
#   -q 15    Minimum quality score
#   -l 800   Minimum read length
#
# ============================================================

# Define input and output directories
INPUT_DIR="/HOME/1-RAW-L/PATH"
OUTPUT_DIR="/HOME/2-TRIMMED-L/PATH"

mkdir -p "$OUTPUT_DIR"

# Loop over all gzipped long-read FASTQ files
for f in "$INPUT_DIR"/*.gz; do

    SAMPLE=$(basename "$f")

    echo "+ Processing $SAMPLE"

    fastplong \
        -i "$f" \
        -o "$OUTPUT_DIR/${SAMPLE%.gz}.trimmed.gz" \
        -q 15 \
        -l 800

done

echo "+ Job $JOB_NAME finished at $(date)"
