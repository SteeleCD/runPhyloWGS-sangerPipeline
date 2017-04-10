#!/bin/bash
resDir=$1
sample=$2
phyloDir=$3
mkdir $resDir/test_results
cd $resDir/test_results
python2 $phyloDir/write_results.py $sample $resDir/trees.zip $resDir/test_results/$sample".summ.json.gz" $resDir/test_results/$sample".muts.json.gz" $resDir/test_results/$sample".mutass.zip"
