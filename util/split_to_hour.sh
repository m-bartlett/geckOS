#!/bin/bash

for img in `ls -1 *.jpg`; do
    timestamp=`echo $img | sed 's/\..*$//'`
    folder=`date -r $timestamp +%H`
    mkdir -p $folder
    echo "$timestamp $folder"
    $(cd $folder; ln -s ../$img)
    # ln -s "./$img" "./$folder/$img"
    # break
done