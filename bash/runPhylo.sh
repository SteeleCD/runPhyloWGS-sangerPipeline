#!/bin/bash
pipelineScript=phyloWGSpipeline.sh
purityFile=/nfs/users/nfs_c/cs32/data/ploidyPurityWGS.csv
samples=$(awk -F "," 'NR!=1 {print $1}' $purityFile)
for i in $samples; do
thisSamp=${i::-1}
echo $thisSamp
source $pipelineScript $thisSamp
done

