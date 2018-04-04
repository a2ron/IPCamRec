#!/bin/bash
mkdir -p ${DIST} ${RECORDS_PATH}
crond
sh scripts/record.sh & >> log/record.log 2>> log/record.err
tail -f log/*