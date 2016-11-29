#!/bin/bash

scriptname=`basename $0`
EXPECTED_ARGS=3
if [ $# -ne $EXPECTED_ARGS ]
then
    echo "Usage: $scriptname processName mmed mchi"
    echo "Example: ./$scriptname Zprime_Zh_Zlephbb 1000 10"
    exit 1
fi

export PRODHOME=`pwd`
name=$1
mmed=$2
ma0=$3

echo ""
echo "Producing input text file for Z' mediator mass = "$mmed" GeV"
echo "Producing input text file for A0 mass = "$ma0" GeV "
echo ""
header=${name}\_MZp${mmed}\_MA0${ma0}

## Now produce input text file for comparison

MDMARRAY=(1 10 100)
inputtextfile=${header}.txt
rm -rf $inputtextfile

for ((i=0; i < ${#MDMARRAY[@]}; i++))
do
  mdm=${MDMARRAY[$i]}
  filename=/data7/monoH/monoH_genOnly/Zp2HDM/varyMDM/output/gentuple_2HDM_MZp${mmed}_MA0${ma0}_MDM${mdm}.root
  legend="MDM="$mdm
  echo $filename $legend >> $inputtextfile
done

cd /afs/cern.ch/work/s/syu/13tev/80X/CMSSW_8_0_20/src
export SCRAM_ARCH=slc6_amd64_gcc530; eval `scramv1 runtime -sh`
cd $PRODHOME

root -q -b /afs/cern.ch/user/s/syu/scripts/dumpCompareMultiplePDF.C++\(\"$inputtextfile\",\"$header\"\)

