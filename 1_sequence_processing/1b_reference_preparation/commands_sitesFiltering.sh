# ============================================================
# Generation of high-quality analysis regions
# Software: GenMap vX.X.X; BEDTools vX.X.X; faidx vX.X.X; ANGSD vX.X.X
# ============================================================

# Reference genome
REFERENCE="/path/to/Iricinus_assembly.fa"

# Input files
AUTOSOMES_BED="/path/to/Iricinus_assembly_autosomes.bed"
REPEATS_BED="/path/to/repeats.sort.bed.gz"

# Temporary directory
mkdir -p tmp
export TMPDIR="tmp/"

# ============================================================
# Genome mappability
# ============================================================

genmap index \
    -F "$REFERENCE" \
    -I genmap_index/ \
    -A divsufsort \
    -v

genmap map \
    -K 150 \
    -E 2 \
    -I genmap_index/ \
    -O Iricinus.assembly.mappability.k150.e2 \
    --bedgraph \
    -T 8 \
    -v

awk '$4 >= 1 {print $1"\t"$2"\t"$3}' \
    Iricinus.assembly.mappability.k150.e2.bedgraph \
    > Iricinus.assembly.mappability.k150.e2.m1.bed

# ============================================================
# Generate BED file for the reference genome
# ============================================================

faidx --transform bed "$REFERENCE" \
    > Iricinus_assembly.bed

cat Iricinus_assembly.bed | \
    awk -F'\t' 'BEGIN{SUM=0}{SUM+=$3-$2}END{print SUM}' \
    > 01_originalRef_sitesNumber.txt

# ============================================================
# Autosomes
# ============================================================

cat "$AUTOSOMES_BED" | \
    awk -F'\t' 'BEGIN{SUM=0}{SUM+=$3-$2}END{print SUM}' \
    > 02_onlyAutosomes_sitesNumber.txt

# ============================================================
# Exclude repetitive regions
# ============================================================

bedtools subtract \
    -a Iricinus_assembly.bed \
    -b "$REPEATS_BED" \
    > Iricinus_assembly_noRepeats.bed

cat Iricinus_assembly_noRepeats.bed | \
    awk -F'\t' 'BEGIN{SUM=0}{SUM+=$3-$2}END{print SUM}' \
    > 02_originalRef_noRepeats_sitesNumber.txt

# ============================================================
# Retain regions with good mappability
# ============================================================

bedtools intersect \
    -a Iricinus_assembly_noRepeats.bed \
    -b Iricinus.assembly.mappability.k150.e2.m1.bed \
    > Iricinus_assembly_noRepeats_goodMappability.bed

cat Iricinus_assembly_noRepeats_goodMappability.bed | \
    awk -F'\t' 'BEGIN{SUM=0}{SUM+=$3-$2}END{print SUM}' \
    > 03_originalRef_noRepeats_goodMappability_sitesNumber.txt

# ============================================================
# Select the 14 main scaffolds
# ============================================================

for i in {1..14}; do
    grep -w "Iricinus_Scaffold_${i}" \
        Iricinus_assembly_noRepeats_goodMappability.bed \
        >> Iricinus_assembly_noRepeats_goodMappability_mainScaffolds.bed
done

cat Iricinus_assembly_noRepeats_goodMappability_mainScaffolds.bed | \
    awk -F'\t' 'BEGIN{SUM=0}{SUM+=$3-$2}END{print SUM}' \
    > 04_originalRef_noRepeats_goodMappability_mainScaffolds_sitesNumber.txt

# Generate ANGSD regions file
awk '{print $1"\t"$2+1"\t"$3}' \
    Iricinus_assembly_noRepeats_goodMappability_mainScaffolds.bed \
    > Iricinus_assembly_noRepeats_goodMappability_mainScaffolds.regions

angsd sites index \
    Iricinus_assembly_noRepeats_goodMappability_mainScaffolds.regions

# ============================================================
# Generate autosomal regions
# Exclude chromosome 12
# ============================================================

for i in 1 2 3 4 5 6 7 8 9 10 11 13 14; do
    grep -w "Iricinus_Scaffold_${i}" \
        Iricinus_assembly_noRepeats_goodMappability_mainScaffolds.bed \
        >> Iricinus_assembly_noRepeats_goodMappability_mainScaffolds_autosomes.bed
done

cat Iricinus_assembly_noRepeats_goodMappability_mainScaffolds_autosomes.bed | \
    awk -F'\t' 'BEGIN{SUM=0}{SUM+=$3-$2}END{print SUM}' \
    > 05_originalRef_noRepeats_goodMappability_mainScaffolds_autosomes_sitesNumber.txt

# Generate ANGSD regions file for autosomes
awk '{print $1"\t"$2+1"\t"$3}' \
    Iricinus_assembly_noRepeats_goodMappability_mainScaffolds_autosomes.bed \
    > Iricinus_assembly_noRepeats_goodMappability_mainScaffolds_autosomes.regions

angsd sites index \
    Iricinus_assembly_noRepeats_goodMappability_mainScaffolds_autosomes.regions
