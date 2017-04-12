#!/bin/bash

#load the enviroment vars
source "env.sh"

#neverending bucle
while [ 1 == 1 ]; do

  #name for the video files
  name=$(date +%Y-%m-%d-%H-%M-%S)

  #launch a video record for specific time
  #NOTE: there is a limit time to avoid blocks if the process fail
  $FFMEPG $LOG -y \
  -stimeout 5 \
  -i $URL -map 0 -c copy \
  -t 3600 \
  -f segment -segment_time 5 \
  -segment_list $RECORDS_PATH/$name.ffconcat \
  $RECORDS_PATH/$name"-%04d.mp4"

  sleep 1

done
