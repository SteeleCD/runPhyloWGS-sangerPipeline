lustreDir=/lustre/scratch117/casm/team154/cs32
phyloDir=/nfs/users/nfs_c/cs32/software/phylowgs
vcfDir=/lustre/scratch117/casm/team154/cs32/output/vcfs
bbDir=/lustre/scratch117/casm/team154/cs32/output/BB
outDir=/lustre/scratch117/casm/team154/cs32/output/phyloWGS
bulkVcf=/nfs/users/nfs_c/cs32/results/bulkConvert/all_variants_30012017.txt
purityFile=/nfs/users/nfs_c/cs32/data/ploidyPurityWGS.csv
sample=$1

# convert sanger vcf to mutect vcf
/software/R-3.3.2/bin/Rscript --vanilla ../R/sangerToMutectPhylo.R "$sample"a $bulkVcf $vcfDir

# add vcf headers
cat ../misc/vcfHeads.txt $vcfDir/"$sample"a.vcf > $vcfDir/"$sample"a.vcf

# get purity
contam=$(grep $sample $purityFile | awk -F "," '{print $2}')
contam=$(echo "1 - $contam"|bc)

# change folder
currDir=$(pwd)
mkdir $outDir/$sample
cd $outDir/$sample

# generate cnv intermediate files
python $phyloDir/parser/parse_cnvs.py -f battenberg -c $contam $bbDir/$sample/tmpBattenberg/"$sample"a_subclones.txt

# generate input params etc
python $phyloDir/parser/create_phylowgs_inputs.py --cnvs sample1=$outDir/$sample/cnvs.txt --vcf-type sample1=mutect_tcga sample1=$vcfDir/"$sample"a.vcf

# run phyloWGS
bsub -q long -R"select[mem>45000] rusage[mem=45000]" -M45000 -J "phylo-$sample" -o $lustreDir/logs/out/phylo-$sample.%J.out -e $lustreDir/logs/error/phylo-$sample.%J.out "cd $outDir/$sample && python $phyloDir/evolve.py --params $outDir/$sample/params.json $outDir/$sample/ssm_data.txt $outDir/$sample/cnv_data.txt"

cd $currDir
