#!/bin/bash
resDir=$1
echo "resDir=$resDir"
sample=$2
phyloDir=$3
echo "phyloDir=$phyloDir"
currDir=$(pwd)
mkdir $resDir/$sample
cd $resDir/$sample
echo "write results"
python2 $phyloDir/write_results.py $sample $resDir/trees.zip $sample".summ.json.gz" $sample".muts.json.gz" $sample".mutass.zip"
echo "finish write results"
cd $currDir
echo "leave write script"
