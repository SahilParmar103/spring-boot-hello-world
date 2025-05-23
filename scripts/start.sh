#!/bin/bash
echo "Starting Java application..."

cd /home/ec2-user/app

# Check Java version
java -version

# Run the JAR
nohup java -jar target/*.jar > app.log 2>&1 &

echo "Application started with PID: $!"
