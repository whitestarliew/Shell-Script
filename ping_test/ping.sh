#!/bin/bash

# Target website
target="www.google.com"

# Output file path
output_file="C:\{yourpath}"

# Function to perform the ping test and save results
function ping_and_log() {
  echo "$(date) - Pinging $target..." >> "$output_file"
  
  # ping "$target" >> "$output_file" 2>&1
  echo "" >> "$output_file"  # Add a blank line for readability
}

# Run the test initially
ping_and_log

# Loop every 30 minutes to repeat the test
while true; do
  sleep 30m
  ping_and_log
done
