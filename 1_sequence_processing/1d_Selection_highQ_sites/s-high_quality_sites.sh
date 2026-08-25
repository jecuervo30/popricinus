# ============================================================
# Selection of high-quality sites from short-read alignments
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
INPUT_DIR="/path/to/mapped_short_reads"
OUTPUT_DIR="/path/to/mapped_filtered_short_reads"
MARKDUP_DIR="$OUTPUT_DIR"

mkdir -p "$OUTPUT_DIR" "$MARKDUP_DIR"

# Main scaffolds
CHROMS=(
    Iricinus_Scaffold_1 Iricinus_Scaffold_2 Iricinus_Scaffold_3
    Iricinus_Scaffold_4 Iricinus_Scaffold_5 Iricinus_Scaffold_6
    Iricinus_Scaffold_7 Iricinus_Scaffold_8 Iricinus_Scaffold_9
    Iricinus_Scaffold_10 Iricinus_Scaffold_11 Iricinus_Scaffold_13
    Iricinus_Scaffold_14
)

# Process samples
for f in "$INPUT_DIR"/*.cram; do

    fname=$(basename "$f" .cram)

    echo "+ Processing sample: $fname"

    # Convert CRAM to sorted BAM
    samtools sort -@ 8 \
        -o "$MARKDUP_DIR/${fname}.sorted.bam" \
        "$f"

    # Mark duplicates
    java $PICARD_JAVA_OPTIONS -Xmx$PICARD_HEAP_SIZE -jar \
        /path/to/picard.jar \
        MarkDuplicates \
        -I "$MARKDUP_DIR/${fname}.sorted.bam" \
        -O "$MARKDUP_DIR/${fname}.sort.markdup.bam" \
        -M "$MARKDUP_DIR/${fname}.metric" \
        --REMOVE_DUPLICATES false

    # Remove intermediate BAM
    rm "$MARKDUP_DIR/${fname}.sorted.bam"

    # Flagstat before filtering
    samtools flagstat -@ 8 \
        "$MARKDUP_DIR/${fname}.sort.markdup.bam" \
        > "$MARKDUP_DIR/${fname}.flagstats"

    # Filter alignments
    samtools view -@ 8 \
        -F 3844 \
        -f 2 \
        -q 20 \
        -h \
        "$MARKDUP_DIR/${fname}.sort.markdup.bam" \
        -b \
        -o "$MARKDUP_DIR/${fname}.sort.markdup.filtered.bam"

    # Flagstat after filtering
    samtools flagstat -@ 8 \
        "$MARKDUP_DIR/${fname}.sort.markdup.filtered.bam" \
        > "$MARKDUP_DIR/${fname}.filtered.flagstats"

    # Remove intermediate BAM
    rm "$MARKDUP_DIR/${fname}.sort.markdup.bam"

    # Index filtered BAM
    samtools index \
        "$MARKDUP_DIR/${fname}.sort.markdup.filtered.bam"

    # Calculate coverage across the main scaffolds
    OUT="$MARKDUP_DIR/${fname}.COVERAGE.txt"
    > "$OUT"

    for CHR in "${CHROMS[@]}"; do
        samtools coverage \
            -m \
            --plot-depth \
            -w 40 \
            -A \
            -r "$CHR" \
            "$MARKDUP_DIR/${fname}.sort.markdup.filtered.bam" \
            >> "$OUT"
    done

    echo "+ Sample $fname complete"

done
