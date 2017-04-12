#!/bin/bash
#the path where record the video parts during the record
RECORDS_PATH="**YOUR_PATH_WHERE_RECORD**"
#the path where to save the final video outputs when parts joined
RECORDS_PATH="**YOUR_PATH_WHERE_SAVE_THE_FINAL_OUTPUTS**"
#the stream source to record
URL="rtsp://**USER**:**PASSWORD**@**IP**:**PORT**/live/ch00_0"
#ffmpeg binary app
FFMEPG="ffmpeg"
#log level for ffmpeg
LOG="-loglevel panic"
