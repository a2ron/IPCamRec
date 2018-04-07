#!/bin/bash

#fetch the concat files list to join video parts
concat_suffix="ffconcat"
regex=".*\.$concat_suffix$"
files=$(ls $RECORDS_PATH | grep $regex)

#foreach list of video parts to join
num=$(ls $RECORDS_PATH | grep $regex -c)
i=0
for f in $files
do
  i=$((i + 1))
  concat_file=$RECORDS_PATH/$f
  video_name=$(echo $f | sed -e "s/.$concat_suffix//g")

  #join the video parts
  $FFMEPG $LOG -y -f concat \
  -i $concat_file \
  -c copy $DIST/$video_name.mp4

  #remove the parts, except the last one because it could be in progress yet
  if [ "$i" -lt "$num"   ]; then
    rm $RECORDS_PATH/$video_name*
  fi

done