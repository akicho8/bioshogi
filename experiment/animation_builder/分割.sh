#!/bin/sh
# ffmpeg -i _output.mp4 -f image2 -r 30 __image2_%04d.png
ffmpeg -i _output.mp4 -f image2 -start_number 0 -r 2 __image2_%04d.png
