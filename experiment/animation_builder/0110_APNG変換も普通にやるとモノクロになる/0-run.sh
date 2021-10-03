#!/bin/sh
rm -f _output*

# https://ch.nicovideo.jp/ieno/blomaga/ar1980679
ffmpeg -v warning -hide_banner -framerate 10000/10000.0 -i input%04d.png                  -y _output1_normal.apng
ffmpeg -v warning -hide_banner -framerate 10000/10000.0 -i input%04d.png -pix_fmt yuv420p -y _output2_yuv420p.apng
ffmpeg -v warning -hide_banner -framerate 10000/10000.0 -i input%04d.png -pix_fmt rgb24   -y _output3_rgb24.apng

# yuv420p と rgb24 は同じっぽい
cmp _output2_yuv420p.apng _output3_rgb24.apng

identify _output*.apng
 
ls -alh _output*.apng
echo "sort by size"
ls -alSrh _output*.apng

open -a 'Google Chrome' _output*.apng

