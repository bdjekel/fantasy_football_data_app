#!/bin/bash

echo "Starting Kafka development environment..."

# Check if already running
if lsof -i :9092 > /dev/null; then
    echo "Port 9092 is already in use"
    exit 1
fi

echo "Starting Kafka server..."
cd /opt/kafka
nohup bin/kafka-server-start.sh config/server.properties > /tmp/kafka.log 2>&1 &
KAFKA_PID=$!
echo $KAFKA_PID > /tmp/kafka.pid

echo "Waiting for Kafka to start..."

# Actually check if Kafka is ready (up to 30 seconds)
for i in {1..30}; do
    if lsof -i :9092 > /dev/null; then
        echo "✅ Kafka started successfully with PID: $KAFKA_PID"
        echo "Logs: tail -f /tmp/kafka.log"
        exit 0
    fi
    sleep 1
    echo -n "."
done

echo ""
echo "❌ Kafka failed to start within 30 seconds"
echo "Check logs: tail /tmp/kafka.log"
exit 1