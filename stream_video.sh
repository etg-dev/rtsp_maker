#!/bin/bash

# Variables
VIDEO_PATH="Black_Swan_2010_Hardsub_HD1080.mp4"  # Path to your video
RTSP_SERVER="rtsp://ffmpeg:ffmpegpass@127.0.0.1:8554/live"  # RTSP URL with credentials

# Check if video file exists
if [[ ! -f "$VIDEO_PATH" ]]; then
    echo "Error: Video file not found: $VIDEO_PATH"
    exit 1
fi

# Start MediaMTX in Docker using Docker Compose
echo "Starting MediaMTX container..."
docker compose up -d

# Wait for the RTSP server to be ready (you can adjust this time if needed)
echo "Waiting for MediaMTX to be ready..."
sleep 5  # Adjust as needed

# Stream the video using FFmpeg
echo "Streaming video to RTSP server..."
ffmpeg -stream_loop -1 -i "$VIDEO_PATH" -rtsp_transport tcp -c:v libx264 -preset ultrafast -tune zerolatency -b:v 500k -c:a aac -strict experimental -r 25 -f rtsp "$RTSP_SERVER"

# Check if FFmpeg command was successful
if [[ $? -eq 0 ]]; then
    echo "Video streaming started successfully."
else
    echo "Error: Failed to stream video."
    exit 1
fi

# Optionally, shut down the Docker container after streaming (uncomment the line below)
#docker compose down
