#!/bin/sh
ffmpeg -v warning -hide_banner -i source.mp4 -metadata title='my title' -metadata comment="my comment" -codec copy -y _output.mp4
ffprobe -hide_banner _output.mp4 2>&1 | grep title
ffprobe -hide_banner _output.mp4 2>&1 | grep comment
