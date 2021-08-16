#!/bin/sh
rm -f _*
duration loop_bgm.m4a
ffmpeg -v warning -ss 0.1 -i loop_bgm.m4a -t 2.5 -y _loop_bgm_cut.m4a
duration _loop_bgm_cut.m4a
ffmpeg -v warning -stream_loop -1 -i _loop_bgm_cut.m4a -t 8 -af "afade=t=in:st=0:d=1,afade=t=out:st=6:d=2" -y _long.m4a
duration _long.m4a
open -a 'google chrome' _long.m4a
