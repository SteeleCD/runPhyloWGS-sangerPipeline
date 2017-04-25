#!/bin/bash
phyloDir=$1
resDir=$2
samples=${ls resDir}
for i in $samples; do
	source jsonRes.sh $resDir $i $phyloDir
	cp -r $resDir/$i/$i $phyloDir/witness/data/
	gunzip $phyloDir/witness/data/*/*.gz
done
python2 $phyloDir/witness/index_data.py
python2 -m $phyloDir/witness/SimpleHTTPServer


