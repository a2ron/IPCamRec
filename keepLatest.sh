#!/bin/bash

# script to remove files in a directory keeping the latest X
#./keepLatest <folder> <number of latest files to keep>

cd $1
rm $(ls | head -n $(($(ls | wc -l) - $2)))
