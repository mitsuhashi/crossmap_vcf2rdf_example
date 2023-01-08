#!/bin/bash

JGADID=$1

HOME=/vcf2rdf

DATA_DIR=/data
VCF_DIR=$DATA_DIR/vcf/
RDF_DIR=$DATA_DIR/rdf/
VCF_FILE=PASS.autosome_PAR_ploidy_2.sites-only.vcf
NUM_OF_VARIANTS_PER_TTL=100000

function vcf2rdf() {
  JGADID=$1
  GRCH=$2
  VCF_DIR=$3
  RDF_DIR=$4

  echo "vcf2rdf $JGADID $GRCH at `date`"

  vcf="$VCF_DIR/$GRCH/$JGADID/$VCF_FILE"
  rdf="$RDF_DIR/$GRCH/$JGADID"

  ./bin/vcf2rdf generate config -a $GRCH $vcf.gz > config_$JGADID_$GRCH.yaml
  ./bin/vcf2rdf convert --no-normalize -c config_$JGADID_$GRCH.yaml $vcf.gz > $rdf.ttl
}

function add_jgad_and_split() {
  JGADID=$1
  GRCH=$2
  RDF_DIR=$3

  echo "add_jgad_and_split $JGADID $GRCH at `date`"

  rdf="$RDF_DIR/$GRCH/$JGADID"
  mkdir -p $rdf
  rm -f $rdf/*
  $HOME/bin/add_jgad_and_split.pl $JGADID $rdf.ttl $NUM_OF_VARIANTS_PER_TTL
}

#
#  Convert TIER1 VCFs to RDFs
#
TIER1_VCFDIR="$VCF_DIR/tier1/"
TIER1_RDFDIR="$RDF_DIR/tier1/"

# run vcf2rdf
vcf2rdf $JGADID GRCh37 $TIER1_VCFDIR $TIER1_RDFDIR

# add JGADID
add_jgad_and_split.pl $JGADID GRCh37 $TIER1_RDFDIR
