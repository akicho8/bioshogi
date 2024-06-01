#!/bin/sh
rm -f _*
# 4手あり
convert -background '#fff' -fill '#888' -bordercolor '#00F' -border 32x32 -size 640x480! -resize 320x240! -gravity center -font /Library/Fonts/Ricty-Regular.ttf -pointsize 64 label:0 _0.png
convert -background '#fff' -fill '#888' -bordercolor '#00F' -border 32x32 -size 640x480! -resize 320x240! -gravity center -font /Library/Fonts/Ricty-Regular.ttf -pointsize 64 label:1 _1.png
convert -background '#fff' -fill '#888' -bordercolor '#00F' -border 32x32 -size 640x480! -resize 320x240! -gravity center -font /Library/Fonts/Ricty-Regular.ttf -pointsize 64 label:2 _2.png
convert -background '#fff' -fill '#888' -bordercolor '#00F' -border 32x32 -size 640x480! -resize 320x240! -gravity center -font /Library/Fonts/Ricty-Regular.ttf -pointsize 64 label:3 _3.png

# 1手0.5秒とする。つまり0.5秒x4=2秒
ffmpeg -v warning -hide_banner -framerate 1000/500 -i _%d.png -c:v libx264 -pix_fmt yuv420p -y _output1.mp4
# open -a 'Google Chrome' _output1.mp4

# 動画が2秒でBGMが5秒なのでBGMは2秒ぶん鳴るはずだが0.5秒ぐらいで切れてしまう
ffmpeg -v warning -i _output1.mp4 -i loop_bgm.m4a -c copy -shortest -y _output2.mp4

open -a 'Google Chrome' _output2.mp4

