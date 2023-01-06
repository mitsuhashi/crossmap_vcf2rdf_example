#!/bin/bash

JGADID=$1

HOME=/crossmap

DATA_DIR=/data
VCF_DIR=$DATA_DIR/vcf/
CHAIN_FILE=$DATA_DIR/crossmap/GRCh38_to_GRCh37.chain.gz
REF_FASTA_FILE=$DATA_DIR/crossmap/Homo_sapiens.GRCh37.dna.primary_assembly.fa.gz
VCF_FILE=PASS.autosome_PAR_ploidy_2.sites-only.vcf

vcf_columns="%CHROM\t%POS\t%ID\t%REF\t%ALT\t%QUAL\t%FILTER\tAC=%INFO/AC;AF=%INFO/AF;AN=%INFO/AN\n"

function crossmap_tier1_dataset(){
  JGADID=$1

  echo "Crossmaping $JGADID at `date`"

  grch38_dir="$VCF_DIR/tier1/GRCh38"
  mkdir -p $grch38_dir/$JGADID  

  #  Select columns specified by $include and normalize multiallelic to biallelic
  #  See https://samtools.github.io/bcftools/bcftools.html#norm
  {
    bcftools view --header-only $grch38_dir/export-$JGADID/$VCF_FILE.gz  
    bcftools query --format $vcf_columns $grch38_dir/export-$JGADID/$VCF_FILE.gz 
  } | bcftools norm -m - - | bgzip -c --thread 8 > $grch38_dir/$JGADID/$VCF_FILE.gz 

  grch37_dir="$VCF_DIR/tier1/GRCh37/$JGADID"
  grch37_vcf="$grch37_dir/$VCF_FILE"
  mkdir -p $grch37_dir/$JGADID  

  # Run CrossMap
  # See http://crossmap.sourceforge.net/#convert-vcf-format-files
  CrossMap.py vcf $CHAIN_FILE $grch38_dir/$JGADID/$VCF_FILE.gz $REF_FASTA_FILE $grch37_vcf
  vcf-sort $grch37_vcf | bgzip -c --threads 8 > $grch37_vcf.gz
  tabix -h $grch37_vcf.gz 
  rm -f $grch37_vcf

  echo "Completed at `date`"
}

crossmap_tier1_dataset $JGADID 

