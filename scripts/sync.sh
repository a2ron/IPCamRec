#!/bin/sh
aws s3 sync $DIST s3://$(echo $S3_BUCKET/$DIST | sed -e "s/\/\//\//g")
aws s3 sync --delete $RECORDS_PATH s3://$(echo $S3_BUCKET/$RECORDS_PATH | sed -e "s/\/\//\//g")

sh $WD/scripts/index.sh > index.html
aws s3 cp index.html  s3://ip-cam-rec/index.html