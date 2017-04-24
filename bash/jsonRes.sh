#!/bin/bash
resDir=$1
sample=$2
phyloDir=$3
mkdir $resDir/$sample
cd $resDir/$sample
python2 $phyloDir/write_results.py $sample $resDir/trees.zip $resDir/$sample/$sample".summ.json.gz" $resDir/$sample/$sample".muts.json.gz" $resDir/$sample/$sample".mutass.zip"
