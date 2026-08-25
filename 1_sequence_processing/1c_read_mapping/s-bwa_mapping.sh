# ============================================================
# Short-read mapping
# Software: BWA v0.7.17; SAMtools v1.19.2
# ============================================================

set -euo pipefail
umask 002

# Reference genome
REFERENCE="/path/to/Iricinus_assembly.fa"

# Input and output directories
FASTQ_DIR="/path/to/trimmed_short_reads"
BAM_DIR="/path/to/mapped_short_reads"

mkdir -p "$BAM_DIR"

echo "+ $(date): job $JOB_NAME started"

# Index reference genome if needed
if [ ! -f "${REFERENCE}.bwt" ]; then
    echo "+ Indexing reference genome: $REFERENCE"
    bwa index "$REFERENCE"
fi

# List of samples
samples=("sample1" "sample2" "sample3" "sample4" "sample5" "sample6" "sample7")

# Alignment and BAM generation
for sample in "${samples[@]}"; do

    echo "+ Processing sample: $sample"

    FORWARD="${FASTQ_DIR}/${sample}_trimmed_R1.fq.gz"
    REVERSE="${FASTQ_DIR}/${sample}_trimmed_R2.fq.gz"
    OUTPUT="${BAM_DIR}/${sample}.fastp.sort.bam"

    bwa mem -t 8 \
        -R "@RG\tID:${sample}\tSM:${sample}\tLB:Illumina\tPL:Illumina" \
        "$REFERENCE" \
        "$FORWARD" \
        "$REVERSE" \
    | samtools view -@ 8 -h - \
    | samtools sort -@ 8 -o "$OUTPUT"

    samtools index "$OUTPUT"

    echo "+ Finished sample: $sample"

done

echo "+ $(date): alignment pipeline completed"
