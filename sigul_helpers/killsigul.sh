#!/bin/bash

pkill -9 -U sigul
PIDS=$(ps aux | egrep -e '/usr/bin/python /usr/share/sigul/*' | grep -v 'grep' | awk '{print $2}')
for PID in $PIDS; do
    echo $PID
    ps aux | fgrep -i $PID
    kill -9 $PID
done
