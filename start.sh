#!/bin/bash
#set -e

# if the log file exists, delete it to avoid useless log content.
FASTDHT_LOG_FILE="$FASTDHT_BASE_PATH/logs/fdhtd.log"
FASTDHT_PID_NUMBER="$FASTDHT_BASE_PATH/data/fdhtd.pid"

if [  -f "$FASTDHT_LOG_FILE" ]; then 
	rm  "$FASTDHT_LOG_FILE"
fi

echo "try to start the fastdht server..."

# start the fastdht server.	
fdhtd /etc/fdht/fdht.conf start

# wait for pid file(important!),the max start time is 5 seconds,if the pid number does not appear in 5 seconds,fastdht start failed.
TIMES=5
while [ ! -f "$FASTDHT_PID_NUMBER" -a $TIMES -gt 0 ]
do
    sleep 1s
	TIMES=`expr $TIMES - 1`
done

# if the fastdht server start successfully, print the started time.
if [ $TIMES -gt 0 ]; then
    echo "the fastdht server started successfully at $(date +%Y-%m-%d_%H:%M)"
	
	# give the detail log address
    echo "please have a look at the log detail at $FASTDHT_LOG_FILE"

    # leave balnk lines to differ from next log.
    echo
    echo
	
	# make the container have foreground process(primary commond!)
    tail -F --pid=`cat $FASTDHT_PID_NUMBER` /dev/null
# else print the error.
else
    echo "the fastdht server started failed at $(date +%Y-%m-%d_%H:%M)"
    echo "please have a look at the log detail at $FASTDHT_LOG_FILE"
    echo
    echo
fi
