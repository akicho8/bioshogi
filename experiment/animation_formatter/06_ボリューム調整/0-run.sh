#!/bin/sh
ffmpeg -v warning -hide_banner -i loop_bgm1.m4a -af volume=0.2 -y _output1.m4a
`open -a 'google chrome' _output1.m4a`
