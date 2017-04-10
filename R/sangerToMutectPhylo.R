#!/usr/bin/end Rscript
args=commandArgs(trailingOnly=TRUE)
# sampleName, bulkVcfFile, vcfDir
print(args)

#CHROM = Chrom
#POS = Pos
#ID = VariantID
#REF = Ref
#ALT = Alt
#QUAL = Qual
#FILTER = Filter
#INFO = SOMATIC
#FORMAT = "TD:ND:TR:NR"
#SAMPLE = values


#TD:ND:TR:NR
#TD = tumour refDepth,altDepth = WTR-Tum,MTR-Tum
#ND = normal refDepth,altDepth = WTR-Norm,MTR-Norm
#TR = tumour read depth = WTR-Tum + MTR-Tum
#NR = normal read depth = WTR-Norm + MTR-Norm

toNumeric = function(x)
	{
	mode(x) = "numeric"
	return(x)
	}

getDepths = function(data)
	{
	normR = colSums(toNumeric(sapply(1:nrow(data),FUN=function(x)
		data[x,paste0(c("F","R"),data$Ref[x],"Z.Norm")])))
	normA = colSums(toNumeric(sapply(1:nrow(data),FUN=function(x)
                data[x,paste0(c("F","R"),data$Alt[x],"Z.Norm")])))
	tumR = colSums(toNumeric(sapply(1:nrow(data),FUN=function(x)
                data[x,paste0(c("F","R"),data$Ref[x],"Z.Tum")])))
	tumA = colSums(toNumeric(sapply(1:nrow(data),FUN=function(x)
                data[x,paste0(c("F","R"),data$Alt[x],"Z.Tum")])))
	return(cbind(normR,normA,tumR,tumA))
	}

convertSangerMutect = function(data)
	{
	index = which(data$Type=="Sub")
	depthsSub = getDepths(data[index,])
	depthsIndel = toNumeric(as.matrix(data[-index,
			c("WTR.Norm","MTR.Norm","WTR.Tum","MTR.Tum")]))
	allDepths = matrix(NA,ncol=4,nrow=nrow(data))
	allDepths[index,] = depthsSub
	allDepths[-index,] = depthsIndel
	colnames(allDepths)=c("WTR.Norm","MTR.Norm","WTR.Tum","MTR.Tum")
	values = paste(
		paste(allDepths[,"WTR.Tum"],allDepths[,"MTR.Tum"],sep=","),
		paste(allDepths[,"WTR.Norm"],allDepths[,"MTR.Norm"],sep=","),
		allDepths[,"WTR.Tum"]+allDepths[,"MTR.Tum"],
		allDepths[,"WTR.Norm"]+allDepths[,"MTR.Norm"],
	sep=":")
	out = data.frame(
		CHROM = data$Chrom,
		POS = data$Pos,
		ID = data$VariantID,
		REF = data$Ref,
		ALT = data$Alt,
		QUAL = data$Qual,
		FILTER = data$Filter,
		INFO = "SOMATIC",
		FORMAT = "TD:ND:TR:NR",
		SAMPLE = values
	)
	colnames(out)[1] = "#CHROM"
	return(out)
	}

# sampleName, bulkVcfFile, vcfDir
data = read.table(args[2],comment.char="@",skip=116,sep="\t",head=TRUE,as.is=TRUE)
sample = args[1]
data = data[which(data$Sample==sample),]
# remove low quality
ASMD = as.numeric(data$ASMD)
keepIndex = which(is.na(ASMD)|ASMD>=140)
data = data[keepIndex,]
CLPM = as.numeric(data$CLPM)
keepIndex = which(is.na(CLPM)|CLPM==0)
data = data[keepIndex,]
# convert
newFormat = convertSangerMutect(data)
write.table(newFormat,file=paste0(args[3],"/",sample),quote=FALSE,row.names=FALSE)
