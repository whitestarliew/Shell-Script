#!/bin/bash

# Target website
target="www.google.com"

# Output file path
output_file="C:\{yourpath}"

# Function to perform the ping test and save results
function ping_and_log() {
   echo "$(date) - Pinging $target..." >> "$output_file"
    ping "$target" | tail -1 >> "$output_file"
  echo "" >> "$output_file" 
}
# Run the test initially
ping_and_log

# Loop every 30 minutes to repeat the test
while true; do
  sleep 30m
  ping_and_log
done
