
#!/bin/bash
# Deploy on AWS: ./deploy.sh <image-version> -> ./run.sh 0.7.0
# Run locally: ./deploy.sh local

rm -r parts/* log/* ;
#dist/*;
docker rm -f $(docker ps -qa -f ancestor=test/test);
docker build -t test/test .;
if  [ "$1" == "local" ] ; then
    
    docker run -d \
    --privileged \
    -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
    -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
    -e S3_BUCKET="homea2" \
    -e REC_KEY="home" \
    -e EXPIRATION="+1 min" \
    -e CHUNK_SECONDS="30" \
    -e FFMPEG_PARAMS="$FFMPEG_PARAMS" \
    -e S3_STORAGE_TYPE="STANDARD" \
    -v $PWD/dist:/streams/dist \
    -e VPN="no" \
    --name test \
    test/test 

    # docker exec -it -u root --privileged $(docker ps -q -f ancestor=test/test) sh
    docker logs -f $(docker ps -q -f ancestor=test/test)
    
else
    NEW_IMAGE_VERSION=$1
    docker tag test/test $DOCKER_REPO:$NEW_IMAGE_VERSION;
    $(aws ecr get-login --no-include-email)
    docker push $DOCKER_REPO:$NEW_IMAGE_VERSION;
fi
