#!/bin/bash

# datasets
TIER1_DATASETS=(
    "JGAD000234"
    "JGAD000235"
    "JGAD000252"
    "JGAD000335"
)

# start up crossmap and vcf2rdf containers
docker-compose up -d

# exec crossmap and vcf2rdf
for JGADID in "${TIER1_DATASETS[@]}" ; do
  docker-compose exec crossmap run.sh $JGADID
  docker-compose exec vcf2rdf run.sh $JGADID
done
