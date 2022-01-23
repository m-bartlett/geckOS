#!/bin/bash
CONTROL="noedges.jpg"
THRESHOLD="0.013"
COMPARE=`ls -1 *.jpg | head -n 1`

# convert $COMPARE -canny 0x1+10%+10% _B.jpg
cp $COMPARE _B.jpg

echo $COMPARE
GECKO=0

for IMG in `ls -1 *.jpg* | tail -n +2`; do
    printf "$IMG "
    mv _B.jpg _A.jpg
    
    # convert $IMG -canny 0x1+10%+10% _B.jpg 
    cp $IMG _B.jpg
    
    DELTA=`compare -metric RMSE _A.jpg _B.jpg NULL: 2>&1 | awk '{ print $2 }'`
    if (( `echo "$DELTA > $THRESHOLD" | bc -l`)); then GECKO=[! $GECKO ]; fi
    printf "$DELTA $GECKO\n"
    # if (( $(echo "$DELTA > $THRESHOLD" |bc -l) )); then
    #     echo "gecko"
    # else
    #     echo "no gecko"
    # fi
    # break
done