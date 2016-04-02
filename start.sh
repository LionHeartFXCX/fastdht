#!/bin/bash
#set -e

# if the log file exists, delete it to avoid useless log content
FASTDHT_LOG_FILE="$FASTDHT_BASE_PATH/logs/fdhtd.log"

if [  -f "$FASTDHT_BASE_PATH/logs/fdhtd.log" ]; then 
	rm  "$FASTDHT_LOG_FILE"
fi

echo "start the fastdht server..."

# start the tracker node	
fdhtd /etc/fdht/fdht.conf start

# wait for pid file(importent!)
sleep 3s

tail -F --pid=`cat $FASTDHT_BASE_PATH/data/fdhtd.pid`  $FASTDHT_BASE_PATH/logs/fdhtd.log