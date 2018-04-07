#!/bin/bash
mkdir -p ${DIST} ${RECORDS_PATH}
crond
sh scripts/record.sh & >> log/record.log 2>> log/record.err
watch -n 5 tail -50 log/*