#!/bin/sh
rm -f _*
# 4手あり
convert -background '#fff' -fill '#888' -bordercolor '#00F' -border 32x32 -size 640x480! -resize 320x240! -gravity center -font /Library/Fonts/Ricty-Regular.ttf -pointsize 64 label:0 _0.png
convert -background '#fff' -fill '#888' -bordercolor '#00F' -border 32x32 -size 640x480! -resize 320x240! -gravity center -font /Library/Fonts/Ricty-Regular.ttf -pointsize 64 label:1 _1.png
convert -background '#fff' -fill '#888' -bordercolor '#00F' -border 32x32 -size 640x480! -resize 320x240! -gravity center -font /Library/Fonts/Ricty-Regular.ttf -pointsize 64 label:2 _2.png
convert -background '#fff' -fill '#888' -bordercolor '#00F' -border 32x32 -size 640x480! -resize 320x240! -gravity center -font /Library/Fonts/Ricty-Regular.ttf -pointsize 64 label:3 _3.png

# 1手2秒とする。つまり2秒x4=8秒
ffmpeg -v warning -hide_banner -framerate 1000/2000 -i _%d.png -c:v libx264 -pix_fmt yuv420p -y _output1.mp4
# open -a 'google chrome' _output1.mp4

# すでに計算で得られたけど、動画からも8.0が得られる
ruby -r json -e 'p JSON.parse(%x(ffprobe -v warning -print_format json -show_entries format=duration -i _output1.mp4))["format"]["duration"].to_f'

# 5秒の素材を繰り返して8秒(正確に8秒ではない)のBGMを作る
ffmpeg -v warning -stream_loop -1 -i loop_bgm.m4a -t 8 -c copy -y _long.m4a
ruby -r json -e 'p JSON.parse(%x(ffprobe -v warning -print_format json -show_entries format=duration -i _long.m4a))["format"]["duration"].to_f'

# 前後をフェイドアウトさせる(処理は↑と一体化できる)
ffmpeg -v warning -i _long.m4a -af "afade=t=in:st=0:d=1,afade=t=out:st=6:d=2" -y _fade.m4a

# 結合する
ffmpeg -v warning -i _output1.mp4 -i _fade.m4a -c copy -y _output2.mp4

open -a 'google chrome' _output2.mp4
