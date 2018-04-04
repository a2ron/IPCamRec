#!/bin/bash

#fetch the concat files list to join video parts
regex=".*\.ffconcat$"
files=$(ls $RECORDS_PATH | grep $regex)

#foreach list of video parts to join
num=$(ls $RECORDS_PATH | grep $regex -c)
i=0
for f in $files
do
  i=$((i + 1))

  #join the video parts
  $FFMEPG $LOG -y -f concat \
  -i $RECORDS_PATH/$f \
  -c copy $DIST/$f.mp4

  #check the list as "done", except the last one because it could be in progress yet
  if [ "$i" -lt "$num"   ]; then
    mv $RECORDS_PATH/$f $RECORDS_PATH/$f".done"
  fi

done

aws s3 sync $DIST s3://$(echo $S3_BUCKET/$DIST | sed -e "s/\/\//\//g")
aws s3 sync $RECORDS_PATH s3://$(echo $S3_BUCKET/$RECORDS_PATH | sed -e "s/\/\//\//g")