#!/bin/sh
# https://nico-lab.net/audio_crossfade_with_ffmpeg/
# https://ffmpeg.org/ffmpeg-filters.html#acrossfade
rm -f _*
ffmpeg -v warning -hide_banner -i loop_bgm1.m4a -i loop_bgm2.m4a -filter_complex acrossfade=d=2 _output1.m4a
duration loop_bgm1.m4a
duration loop_bgm2.m4a
duration _output1.m4a
# open -a 'google chrome' _output1.m4a
