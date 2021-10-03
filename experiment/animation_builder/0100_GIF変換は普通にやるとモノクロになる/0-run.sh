#!/bin/sh
rm -f _output*

# https://qiita.com/yusuga/items/ba7b5c2cac3f2928f040
# https://nico-lab.net/optimized_256_colors_with_ffmpeg

ffmpeg -v warning -hide_banner -framerate 10000/10000.0 -i input%04d.png                                                                                                   -y _output1.gif
ffmpeg -v warning -hide_banner -framerate 10000/10000.0 -i input%04d.png -filter_complex "[0:v] split [a][b];[a] palettegen=stats_mode=full:reserve_transparent=0 [p];[b][p] paletteuse=new=1"   -y _output2_full.gif
ffmpeg -v warning -hide_banner -framerate 10000/10000.0 -i input%04d.png -filter_complex "[0:v] split [a][b];[a] palettegen=stats_mode=diff:reserve_transparent=0 [p];[b][p] paletteuse=new=1"   -y _output3_diff.gif
ffmpeg -v warning -hide_banner -framerate 10000/10000.0 -i input%04d.png -filter_complex "[0:v] split [a][b];[a] palettegen=stats_mode=single:reserve_transparent=0 [p];[b][p] paletteuse=new=1" -y _output4_single.gif
ffmpeg -v warning -hide_banner -framerate 10000/10000.0 -i input%04d.png -pix_fmt rgb24 -y _output5_rgb24.gif

# full, diff
identify _output*.gif

ls -alh _output*.gif
echo "sort by size"
ls -alSrh _output*.gif

# exiftool -json _output1.gif
open -a 'Google Chrome' _output*.gif

# _output4_single がいちばん綺麗
