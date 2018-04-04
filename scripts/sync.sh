#!/bin/sh
aws s3 sync $DIST s3://$(echo $S3_BUCKET/$DIST | sed -e "s/\/\//\//g")
aws s3 sync $RECORDS_PATH s3://$(echo $S3_BUCKET/$RECORDS_PATH | sed -e "s/\/\//\//g")