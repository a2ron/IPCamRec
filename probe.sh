#!/bin/bash

#load the enviroment vars
source "env.sh"

bin/ffprobe $LOG  -i $URL
