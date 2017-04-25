#!/bin/bash
#phyloDir=$1
#resDir=$2
samples=$(ls $2)
for i in $samples; do
	echo $i
	echo json
	source jsonRes.sh $2/$i $i $1
	echo move
	cp -r $2/$i/$i $1/witness/data/
	echo unzip
	gunzip $1/witness/data/$i/*.gz
done
echo index
cd $1/witness
python2 index_data.py
echo server
python2 -m SimpleHTTPServer

# http://127.0.0.1:8000

