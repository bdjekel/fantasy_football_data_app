#!/bin/bash

echo "Stopping Kafka..."

if [ -f /tmp/kafka.pid ]; then
    PID=$(cat /tmp/kafka.pid)
    if kill -0 $PID 2>/dev/null; then
        kill $PID
        echo "Kafka stopped (PID: $PID)"
        rm /tmp/kafka.pid
    else
        echo "Kafka process not running"
    fi
else
    echo "No Kafka PID file found"
fi