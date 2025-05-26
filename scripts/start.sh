#!/bin/bash
echo "Starting Java application..."

cd /home/ec2-user/app

if ls target/*.jar 1> /dev/null 2>&1; then
  nohup java -jar target/*.jar > app.log 2>&1 &
  echo "Application started with PID: $!"
else
  echo "JAR file not found in target/. Cannot start application."
  exit 1
fi
