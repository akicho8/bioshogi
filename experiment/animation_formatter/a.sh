#!/bin/sh
ffmpeg -r 0.5 -y -i _output.mp4 _ffmpeg0_5.mp4
ffmpeg -r 1   -y -i _output.mp4 _ffmpeg1.mp4
ffmpeg -r 2   -y -i _output.mp4 _ffmpeg2.mp4
ffmpeg -r 25  -y -i _output.mp4 _ffmpeg25.mp4
ffmpeg -r 30  -y -i _output.mp4 _ffmpeg30.mp4
