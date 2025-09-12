#!/bin/bash

# GitHub Heatmap Scheduler for Linux/Mac
# This script runs the heatmap generator at scheduled intervals

echo "Starting GitHub Heatmap Scheduler..."
echo "Press Ctrl+C to stop"

while true; do
    # Make a commit
    node github-heatmap.js single
    
    # Wait for 2-4 hours (randomized)
    delay=$((RANDOM % 7200 + 7200))
    echo "Waiting $delay seconds until next commit..."
    
    sleep $delay
done
