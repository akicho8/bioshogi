#!/bin/sh

ffmpeg -hide_banner -i ds8705.mp3  -c:a aac -strict experimental -vn -y ds8705.m4a

ffmpeg -hide_banner -i ds2142.mp3  -c:a aac -strict experimental -vn -y ds2142.m4a
ffmpeg -hide_banner -i ds10827.mp3 -c:a aac -strict experimental -vn -y ds10827.m4a
ffmpeg -hide_banner -i ds8680.mp3  -c:a aac -strict experimental -vn -y ds8680.m4a
ffmpeg -hide_banner -i ds5615.mp3  -c:a aac -strict experimental -vn -y ds5615.m4a
ffmpeg -hide_banner -i ds13982.mp3 -c:a aac -strict experimental -vn -y ds13982.m4a
ffmpeg -hide_banner -i ds4520.mp3  -c:a aac -strict experimental -vn -y ds4520.m4a
ffmpeg -hide_banner -i ds568.mp3   -c:a aac -strict experimental -vn -y ds568.m4a
ffmpeg -hide_banner -i ds1022.mp3  -c:a aac -strict experimental -vn -y ds1022.m4a

# exit

ffmpeg -hide_banner -i ds1982.mp3  -c:a aac -strict experimental -vn -y ds1982.m4a

# exit

ffmpeg -hide_banner -i ds14640.mp3  -c:a aac -strict experimental -vn -y ds14640.m4a
ffmpeg -hide_banner -i ds4616.mp3   -c:a aac -strict experimental -vn -y ds4616.m4a
ffmpeg -hide_banner -i ds8680.mp3   -c:a aac -strict experimental -vn -y ds8680.m4a

ffmpeg -hide_banner -i nc107860.mp3 -c:a aac -strict experimental -vn -y nc107860.m4a

ffmpeg -hide_banner -i nc162705.mp3 -c:a aac -strict experimental -vn -y nc162705.m4a
ffmpeg -hide_banner -i nc55257.wav  -c:a aac -strict experimental -vn -y nc55257.m4a
ffmpeg -hide_banner -i nc97718.wav  -c:a aac -strict experimental -vn -y nc97718.m4a
ffmpeg -hide_banner -i ds4712.mp3   -c:a aac -strict experimental -vn -y ds4712.m4a

ffmpeg -hide_banner -i ds3895.mp3   -c:a aac -strict experimental -vn -y ds3895.m4a
ffmpeg -hide_banner -i ds13037.mp3  -c:a aac -strict experimental -vn -y ds13037.m4a

ffmpeg -hide_banner -i ds5616.mp3             -c:a aac -strict experimental -vn -y ds5616.m4a
ffmpeg -hide_banner -i nc142538.mp3           -c:a aac -strict experimental -vn -y nc142538.m4a

ffmpeg -hide_banner -i shw_akatsuki_japan.mp3 -c:a aac -strict experimental -vn -y shw_akatsuki_japan.m4a

ffmpeg -hide_banner -i ds3479.mp3              -c:a aac -strict experimental -vn -y ds3479.m4a
ffmpeg -hide_banner -i ds6574.mp3              -c:a aac -strict experimental -vn -y ds6574.m4a

ffmpeg -hide_banner -i ds11184.mp3             -c:a aac -strict experimental -vn -y ds11184.m4a
ffmpeg -hide_banner -i ds3480.mp3              -c:a aac -strict experimental -vn -y ds3480.m4a

ffmpeg -hide_banner -i ds3812.mp3              -c:a aac -strict experimental -vn -y ds3812.m4a
ffmpeg -hide_banner -i ds7138.mp3              -c:a aac -strict experimental -vn -y ds7138.m4a

ffmpeg -hide_banner -i ds1245.mp3              -c:a aac -strict experimental -vn -y ds1245.m4a

volume-normalize *.m4a
