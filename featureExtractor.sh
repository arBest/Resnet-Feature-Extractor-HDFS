#!/bin/bash

printUsage() {
 echo "$0 HDFSinput data cache outFile HDFSoutput model nGPU batchSize"
 echo "  HDFSinput  data path on HDFS"
 echo "  data       data path on computron"
 echo "  cache      cache, for faster access"
 echo "  outFile    feature file on computron"
 echo "  HDFSoutput feature path on HDFS"
 echo "  model      resnet architecture"
 echo "  nGPU       How many GPUs ? "  
 echo "  batchSize  What is the batch size you want ? "
}

if [ "$1" = "-help" ]; then 
  printUsage
  exit 0 
fi

if [ $# -ne 8 ]; then 
  >&2 echo "Not enough args"
  printUsage
  exit 1 
fi

#print all args 
for i in $*;do 
  echo $i
done  


th main.lua -HDFSinput $1 -data $2 -cache $3 -outFile $4 -HDFSoutput $5 -model $6 -nGPU $7 -batchSize $8
