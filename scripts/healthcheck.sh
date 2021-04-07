#!/bin/sh

taint=$(cat $WD/taint)
if [ "$taint" == "1" ]; then
    echo "Container tainted, exiting" >> ${WD}/log.log 
    pkill tail
    pkill sh
    exit 1
fi
# check 
previousSize=$(cat $WD/previousSize.txt)
if [ $? -ne 0 ];then
    previousSize=0
fi
currentSize=$(du $RECORDS_PATH/ | awk '{print $1}')

if [ $currentSize -gt $previousSize ]; then
    echo $currentSize > $WD/previousSize.txt
    exit 0
else
    echo "Healtcheck fails, killing ffmpeg" >> ${WD}/log.log 
    pkill ffmpeg
    rm $WD/previousSize.txt
    exit 1
fi