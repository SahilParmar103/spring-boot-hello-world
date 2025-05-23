#!/bin/bash
echo "Stopping running Java application..."
PID=$(pgrep -f 'target/.*\.jar')
if [ -n "$PID" ]; then
  kill $PID
  echo "Stopped process $PID"
else
  echo "No Java process found."
fi
