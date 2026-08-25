
# ============================================================
# Long-read alignment filtering and duplicate assessment
# Software: Picard v3.1.1; SAMtools v1.19.2
# ============================================================

set -euo pipefail

# Environment
export PICARD_HEAP_SIZE="16g"
export PICARD_JAVA_OPTIONS="-server"
unset _JAVA_OPTIONS

TMP_DIR="/path/to/tmp"
mkdir -p "$TMP_DIR"

# Input and output directories
INPUT_DIR="/path/to/mapped_filtered_long_reads"
OUTPUT_DIR="/path/to/mapped_filtered_long_reads_final"
MARKDUP_DIR="$OUTPUT_DIR"

mkdir -p "$OUTPUT_DIR" "$TMP_DIR"

echo "+ $(date): job $JOB_NAME started"

# Process samples
for f in "$INPUT_DIR"/*rg.bam; do

    fname=$(basename "$f" rg.bam)

    echo "+ Processing sample: $fname"

    # Mark duplicates
    java $PICARD_JAVA_OPTIONS -Xmx$PICARD_HEAP_SIZE -jar \
        /path/to/picard.jar \
        MarkDuplicates \
        -I "$f" \
        -O "$MARKDUP_DIR/${fname}.sort.markdup.bam" \
        -M "$MARKDUP_DIR/${fname}.metric" \
        --REMOVE_DUPLICATES false \
        --VALIDATION_STRINGENCY LENIENT

    # Pre-filter statistics
    samtools flagstat -@ 8 \
        "$MARKDUP_DIR/${fname}.sort.markdup.bam" \
        > "$MARKDUP_DIR/${fname}.flagstats"

    # Filter alignments
    samtools view -@ 8 \
        -F 2308 \
        -q 20 \
        -h \
        "$MARKDUP_DIR/${fname}.sort.markdup.bam" \
        -b \
        -o "$MARKDUP_DIR/${fname}.sort.markdup.filtered.bam"

    # Post-filter statistics
    samtools flagstat -@ 8 \
        "$MARKDUP_DIR/${fname}.sort.markdup.filtered.bam" \
        > "$MARKDUP_DIR/${fname}.filtered.flagstats"

    # Remove intermediate BAM
    rm "$MARKDUP_DIR/${fname}.sort.markdup.bam"

    echo "+ Sample $fname processed"

done

echo "+ $(date): job $JOB_NAME finished"
