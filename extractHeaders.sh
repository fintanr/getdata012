#!/bin/bash
#
# extract out the column headers for our codebook
#

TIDY_DATA=tidy-data.txt
CODEBOOK_TMP=codebook-tmp.txt

if [ ! -f $TIDY_DATA ]; then
    echo "$TIDY_DATA not found, have you run run_analysis.R"
    exit 1
fi

[ -f $CODEBOOK_TMP ] && rm $CODEBOOK_TMP

for i in `head -1 $TIDY_DATA`
do
    let j=$j+1
    COLHEAD=$(echo $i | sed -e "s/\"//g")
    echo "$j. $COLHEAD" >> $CODEBOOK_TMP
done
