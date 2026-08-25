# ============================================================
# Long-read mapping
# Software: minimap2 v2.28; SAMtools v1.19.2
# ============================================================

set -euo pipefail

# Reference genome
REFERENCE="/path/to/Iricinus_assembly.fa"

# Input and output directories
INPUT_DIR="/path/to/trimmed_long_reads"
OUTPUT_DIR="/path/to/mapped_filtered_long_reads"

mkdir -p "$OUTPUT_DIR"

echo "+ $(date): job $JOB_NAME started"

for f in "$INPUT_DIR"/*.trimmed.gz; do

    SAMPLE=$(basename "$f" .trimmed.gz)

    echo "+ Processing $SAMPLE"

    # Step 1: Alignment and sorting
    minimap2 -t "$NSLOTS" -ax map-ont \
        "$REFERENCE" "$f" \
    | samtools view -hbu - \
    | samtools sort \
        -T "${OUTPUT_DIR}/${SAMPLE}.tmp" \
        -@ 30 \
        -o "${OUTPUT_DIR}/${SAMPLE}.sorted.bam"

    # Step 2: Add read group
    samtools addreplacerg \
        -r "ID:$SAMPLE" \
        -r "SM:$SAMPLE" \
        -r "PL:ONT" \
        -o "${OUTPUT_DIR}/${SAMPLE}.rg.bam" \
        "${OUTPUT_DIR}/${SAMPLE}.sorted.bam"

    # Step 3: Index final BAM
    samtools index "${OUTPUT_DIR}/${SAMPLE}.rg.bam"

done

echo "+ $(date): job $JOB_NAME finished"
