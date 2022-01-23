#!/bin/bash
BATCH_SIZE=${1:-5}
# IMAGE_TOTAL=`expr 505`
IMAGE_TOTAL=`ls -1 *.jpg | wc -l`
BATCH_WINDOWS=($(seq  0 $BATCH_SIZE $IMAGE_TOTAL))
LEVEL=0
LAST=${BATCH_WINDOWS[${#BATCH_WINDOWS[@]}-1]}
unset 'BATCH_WINDOWS[${#BATCH_WINDOWS[@]}-1]'
mkdir -p batch

FRAME=0

for i in ${BATCH_WINDOWS[@]}; do
    CURRENT_BATCH=""
    FRAME_NAME=`printf "%04d.jpg" $FRAME`
    for _i in `seq $i \`expr $i + \\\`expr $BATCH_SIZE - 1\\\`\``; do
        CURRENT_BATCH+=`printf "%04d.jpg " $_i`
    done
    printf "$CURRENT_BATCH >> $FRAME_NAME\n"
    convert $CURRENT_BATCH -average "./batch/$FRAME_NAME"
    ((FRAME++))
    # seq -s " " $i `expr $i + \`expr $BATCH_SIZE - 1\````
done

seq -s " " $LAST $IMAGE_TOTAL
printf " >> %d\n" $FRAME
