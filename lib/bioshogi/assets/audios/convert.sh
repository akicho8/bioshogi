#!/bin/sh

ffmpeg -hide_banner -i nc43122.mp3  -c:a aac -strict experimental -vn -y nc43122.m4a
ffmpeg -hide_banner -i nc105702.mp3 -c:a aac -strict experimental -vn -y nc105702.m4a
ffmpeg -hide_banner -i nc107860.mp3 -c:a aac -strict experimental -vn -y nc107860.m4a
ffmpeg -hide_banner -i nc3366.mp3   -c:a aac -strict experimental -vn -y nc3366.m4a
ffmpeg -hide_banner -i nc35943.mp3  -c:a aac -strict experimental -vn -y nc35943.m4a
ffmpeg -hide_banner -i nc768.mp3    -c:a aac -strict experimental -vn -y nc768.m4a
ffmpeg -hide_banner -i nc770.mp3    -c:a aac -strict experimental -vn -y nc770.m4a
ffmpeg -hide_banner -i nc162705.mp3 -c:a aac -strict experimental -vn -y nc162705.m4a
ffmpeg -hide_banner -i nc55257.wav  -c:a aac -strict experimental -vn -y nc55257.m4a
ffmpeg -hide_banner -i nc97718.wav  -c:a aac -strict experimental -vn -y nc97718.m4a
ffmpeg -hide_banner -i ds4712.mp3   -c:a aac -strict experimental -vn -y ds4712.m4a
ffmpeg -hide_banner -i ds7615.mp3   -c:a aac -strict experimental -vn -y ds7615.m4a
ffmpeg -hide_banner -i ds3895.mp3   -c:a aac -strict experimental -vn -y ds3895.m4a
ffmpeg -hide_banner -i ds13037.mp3  -c:a aac -strict experimental -vn -y ds13037.m4a
ffmpeg -hide_banner -i ds4000.mp3   -c:a aac -strict experimental -vn -y ds4000.m4a
ffmpeg -hide_banner -i ds12450.mp3  -c:a aac -strict experimental -vn -y ds12450.m4a

ffmpeg -hide_banner -i ds5837.mp3             -c:a aac -strict experimental -vn -y ds5837.m4a
ffmpeg -hide_banner -i ds5616.mp3             -c:a aac -strict experimental -vn -y ds5616.m4a
ffmpeg -hide_banner -i nc142538.mp3           -c:a aac -strict experimental -vn -y nc142538.m4a
ffmpeg -hide_banner -i nc176917.mp3           -c:a aac -strict experimental -vn -y nc176917.m4a
ffmpeg -hide_banner -i shw_akatsuki_japan.mp3 -c:a aac -strict experimental -vn -y shw_akatsuki_japan.m4a

ffmpeg -hide_banner -i ds3479.mp3              -c:a aac -strict experimental -vn -y ds3479.m4a
ffmpeg -hide_banner -i ds6574.mp3              -c:a aac -strict experimental -vn -y ds6574.m4a
ffmpeg -hide_banner -i ds11293.mp3             -c:a aac -strict experimental -vn -y ds11293.m4a
ffmpeg -hide_banner -i ds11459.mp3             -c:a aac -strict experimental -vn -y ds11459.m4a
ffmpeg -hide_banner -i ds6719.mp3              -c:a aac -strict experimental -vn -y ds6719.m4a
ffmpeg -hide_banner -i ds11184.mp3             -c:a aac -strict experimental -vn -y ds11184.m4a
ffmpeg -hide_banner -i ds3480.mp3              -c:a aac -strict experimental -vn -y ds3480.m4a
ffmpeg -hide_banner -i ds14226.mp3             -c:a aac -strict experimental -vn -y ds14226.m4a
ffmpeg -hide_banner -i ds3812.mp3              -c:a aac -strict experimental -vn -y ds3812.m4a
ffmpeg -hide_banner -i ds7138.mp3              -c:a aac -strict experimental -vn -y ds7138.m4a
ffmpeg -hide_banner -i ds2776.mp3              -c:a aac -strict experimental -vn -y ds2776.m4a
ffmpeg -hide_banner -i ds1245.mp3              -c:a aac -strict experimental -vn -y ds1245.m4a
ffmpeg -hide_banner -i nc145888.mp3            -c:a aac -strict experimental -vn -y -t 2:08 nc145888.m4a
ffmpeg -hide_banner -i shw_tsudzumi_japan3.mp3 -c:a aac -strict experimental -vn -y shw_tsudzumi_japan3.m4a

volume-normalize *.m4a
