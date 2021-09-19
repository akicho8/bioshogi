#!/bin/sh
ffmpeg -v warning -hide_banner -i bgm1.m4a -t 4 -af volume=0.2 -y _bgm1a.m4a
ffmpeg -v warning -hide_banner -i bgm1.m4a -t 4 -af volume=0.4 -y _bgm1b.m4a
ffmpeg -v warning -i _bgm1a.m4a -i _bgm1b.m4a -filter_complex "concat=n=2:v=0:a=1" -y _bgm1c.m4a
ffmpeg -v warning -i _bgm1c.m4a -af volume=3.0 -y _output.m4a
`open -a 'google chrome' _output.m4a`
