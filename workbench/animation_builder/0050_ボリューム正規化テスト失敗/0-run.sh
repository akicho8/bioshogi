#!/bin/sh
# https://www.subcul-science.com/post/20210522ffmpegnorm/
ffmpeg -v warning -hide_banner -i loop_bgm1.m4a -af loudnorm=I=-16:LRA=11:TP=-1.5   -y _output0.m4a
ffmpeg -v warning -hide_banner -i _output0.m4a -af "afftdn=nf=-25"                  -y _output1.m4a
ffmpeg -v warning -hide_banner -i _output1.m4a -af "highpass=f=200, lowpass=f=3000" -y _output2.m4a
ffmpeg -v warning -hide_banner -i _output2.m4a -af silenceremove=1:0:-10dB          -y _output3.m4a

ffmpeg -hide_banner -i loop_bgm1.m4a -vn -af volumedetect -f null -

ls -al *.m4a
