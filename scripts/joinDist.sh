#!/bin/sh
numFiles=$(ls $DIST/*.mp4  | wc | awk '{print $1}')
if [ $numFiles -le 1 ];then
    exit 1
fi
currentPath=$(pwd)
cd $DIST/
ls *.mp4 > files.txt
cat files.txt | sed "s/ /\n/g" |  sed "s/^/file '/g" |  sed "s/$/'/g" > list.concat
finalName=$(cat files.txt | head -1)
output=$(ls *.mp4 | head -1).join.mp4
echo "Joining into $finalName"
ffmpeg -y -loglevel $LOG_LEVEL -f concat -safe 0 -i list.concat -c copy $output
rm $(cat files.txt)
rm files.txt
rm list.concat
mv $output $finalName
cd $currentPath
