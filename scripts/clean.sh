#!/bin/sh

pattern=$(date -d "$CLEAN_AGO" "+%Y-%m-%d")
find $RECORDS_PATH -name $pattern* -delete
