#!/bin/bash
#phyloDir=$1
#resDir=$2
samples=$(ls $2)
for i in $samples; do
	source jsonRes.sh $2/$i $i $1
	cp -r $2/$i/$i $1/witness/data/
	gunzip $1/witness/data/$i/*.gz
done
cd $1/witness
python2 index_data.py
python2 -m SimpleHTTPServer

# http://127.0.0.1:8000

