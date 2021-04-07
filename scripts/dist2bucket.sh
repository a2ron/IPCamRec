#!/bin/sh
numFiles=$(ls $DIST/*.mp4  | wc | awk '{print $1}')
if [ $numFiles -le 0 ];then
    exit 1
fi
if [ "$1" == "--force" ]; then
    FORCE_MODE=1
fi
# JOIN
# sh ${WD}/scripts/joinDist.sh
# S3
ls -l $DIST/*.mp4
for f in $DIST/*.mp4; do
    filename=$(basename $f)
    durationSeconds=$(ffmpeg -i $f 2>&1 | awk '/Duration/ {split($2,a,":");print a[1]*3600+a[2]*60+a[3]}' | awk -F . '{print $1}')
    echo "$filename lasts $durationSeconds seconds/$(du -h $f)"
    chunkSecondsThreshold=$(echo $CHUNK_SECONDS | awk '{print $1*0.9}')
    if [ "$FORCE_MODE" == "1" ] || ( [ "$durationSeconds" != "" ] && [ $durationSeconds -ge $chunkSecondsThreshold ] ); then
        s3Path="$S3_BUCKET/$filename"
        echo "Uploading $s3Path"
        aws s3 cp --storage-class "$S3_STORAGE_TYPE" $f s3://$(echo $s3Path | sed -e "s/\/\//\//g") 
        error_code=$?
        if [ "$error_code" ==  "0" ]; then
            rm $f
        else
            echo "Upload $s3Path failed"
        fi
    else
        echo "$filename is not ready yet"
    fi
    
done
sh ${WD}/scripts/clean.sh
