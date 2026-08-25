# ============================================================
# Repetitive region masking
# Software: BEDTools vX.X.X; SAMtools vX.X.X
# ============================================================

# Reference genome
REFERENCE="/path/to/Iricinus_assembly.fa"

# Convert GFF annotation to BED
awk 'BEGIN{OFS="\t"} !/^#/ {print $1, $4 - 1, $5}' \
    I_ricinus.fa.TEs.gff > repeats.bed

# Mask repetitive regions in the reference genome
bedtools maskfasta \
    -fi "$REFERENCE" \
    -bed repeats.bed \
    -fo Iricinus_assembly_masked.fa

# Index masked reference genome
samtools faidx Iricinus_assembly_masked.fa

# Generate chromosome sizes
cut -f1,2 Iricinus_assembly_masked.fa.fai > genome.chrom.sizes

# Sort repetitive regions
bedtools sort \
    -i repeats.bed \
    -faidx Iricinus_assembly_masked.fa.fai \
    > repeats.sort.bed
