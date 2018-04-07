#!/bin/bash

#neverending bucle
while [ 1 == 1 ]; do

  #name for the video files
  name=$(date +%Y-%m-%d-%H-%M-%S)

  #launch a video record for specific time
  #NOTE: there is a limit time to avoid blocks if the process fail
  $FFMEPG $LOG -y \
  -i $URL -map 0 -c copy \
  -t 9000 \
  -f segment -segment_time 1 \
  -segment_list $RECORDS_PATH/$name.ffconcat \
  -b 1000000 \
  -vcodec libx264 \
  -filter:v "setpts=4.2*PTS" \
  $RECORDS_PATH/$name"-%04d.mp4"

  sleep 0.5

done
