#!/bin/sh
# set -x

# define expiration time if needed
expirationDate=""
if [ "$EXPIRATION" != "" ]; then
    expirationDate=$(date +%s -d "$EXPIRATION") #i.e '+1 hour'
fi

currentChunkSeconds=$CHUNK_SECONDS
#record bucle
while [ 1 == 1 ]; do
    
    #name for the video files
    name="$(date +%Y-%m-%d__%H-%M-%S)"
    echo "Recording $name for $currentChunkSeconds seconds"
    #launch a video record for specific time
    command="
    $FFMEPG -loglevel $LOG_LEVEL -y \
    $FFMPEG_PARAMS -t $currentChunkSeconds \
    -f segment \
    -segment_list $RECORDS_PATH/$name.ffconcat \
    $RECORDS_PATH/$name-%010d.mp4"
    ini=$(date +%s)
    $command
    fin=$(date +%s)
    elapsed=$((fin - ini))
    currentChunkSeconds=$((currentChunkSeconds - elapsed))
    chunkSecondsThreshold=$(echo $CHUNK_SECONDS | awk '{print $1*0.1}')
    if [[ $currentChunkSeconds -lt $chunkSecondsThreshold ]]; then
        currentChunkSeconds=$CHUNK_SECONDS
    fi

    # finishing record chunk
    now=$(date +%s)
    if [ "$expirationDate" != "" ] && [ $expirationDate -lt $now ] ; then
        sh ${WD}/scripts/parts2dist.sh
        sh ${WD}/scripts/dist2bucket.sh --force
        echo "Finishing $name and exit"
        sleep 3
        exit 0
    else
        sh -c "sh ${WD}/scripts/parts2dist.sh; sh ${WD}/scripts/dist2bucket.sh --force; echo 'Finishing $name'" & 
    fi
    sleep 0.5
done
