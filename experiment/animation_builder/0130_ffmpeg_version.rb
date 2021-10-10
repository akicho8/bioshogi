require "../setup"
require "rmagick"

sfen = "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f 7a6b 5g5f 8d8e 8h7g"
sfen = "position startpos moves 7g7f 8c8d 2g2f"
info = Parser.parse(sfen)
mediator = info.mediator_for_image
image_renderer = ImageRenderer.new(mediator, viewpoint: "black")
list = [nil, *info.move_infos]
list.each.with_index do |e, i|
  mediator.execute(e[:input]) if e
  image_renderer.render.write("_#{i}.png")
end

page_duration = 2.0
base = 1000
framerate = "#{base}/#{(base * page_duration).to_i}"

total = list.size * page_duration         # => 8.0
framerate                       # => "1000/2000"

`ffmpeg -v warning -hide_banner -framerate #{framerate} -i _%d.png -c:v libx264 -pix_fmt yuv420p -y _output1.mp4`
# `open -a 'Google Chrome' _output1.mp4`

# すでに計算で得られたけど、動画からも8.0が得られる
`duration _output1.mp4`         # => "8.0\n"

# # 5秒の素材を繰り返して8秒(正確に8秒ではない)のBGMを作る
`ffmpeg -v warning -stream_loop -1 -i loop_bgm.m4a -t #{total} -af "afade=t=in:st=0:d=1,afade=t=out:st=6:d=2" -y _fade.m4a`
`duration loop_bgm.m4a`         # => "3.018594\n"
`duration _fade.m4a`            # => "8.0\n"

# # 前後をフェイドアウトさせる(処理は↑と一体化できる)
# ffmpeg -v warning -i _long.m4a -af "afade=t=in:st=0:d=1,afade=t=out:st=6:d=2" -y _fade.m4a

# # 結合する
`ffmpeg -v warning -i _output1.mp4 -i _fade.m4a -c copy -y _output2.mp4`
`open -a 'Google Chrome' _output2.mp4`
