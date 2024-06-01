#!/bin/sh
ffmpeg -v warning -i source.mp4 -itsoffset 2 -i loop_bgm1.m4a -c copy -y _output.mp4
`open -a 'Google Chrome' _output.mp4`
