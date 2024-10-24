require "../setup"
require 'active_support/core_ext/benchmark'
require "rmagick"
# @sfen = "position startpos moves 7g7f 8c8d 2g2f"
# @sfen = "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f 7a6b 5g5f 8d8e 8h7g 5c5d 2h5h 6b5c 7i6h 5a4b 5i4h 3a3b 4h3h 4c4d 5f5e 3b4c 5e5d 4c5d 6h5g 5d6e 5g5f 6e7f 5f5e 7f6g+ P*5d 5c6b 5h5f 6g7g 8i7g B*3d 5f6f P*5b 6i7i 8b8d 5e4d 8d7d P*7h 7d5d S*4c 3d4c 4d4c+ 4b4c B*7f 5b5c 7i6h 4c3b 6h5h P*4c 7f5d 5c5d 8g8f B*7i 8f8e P*8b 6f8f 7i3e+ 8e8d S*7b 8f8i 3e4e P*6g 7c7d 9g9f 4e5f 8i8f 5f5e 9f9e 5e6d 8f8i 7d7e 7g8e 5d5e 8e9c+ 8a9c 9e9d P*9h 9i9h 6d6e 8i8f 6e9h 9d9c+ 9a9c R*9a 9h6e 9a9c+ 5e5f 5h4h L*9b 9c8b P*8a N*7g 6e7d 8b9a S*8b 9a8b 8a8b S*6e 7d9f 8f5f 9f7h 7g8e 7h6g P*7c 7b8a P*9c 6c6d P*6h 6g8e 9c9b+ 8a9b 7c7b+ 6a7b 6e5d N*4b 5d5c+ P*5d 5c6b 7b6b L*2f R*6i L*2e N*3a 5f4f S*3d 3g3f 6b5c 2i3g 4c4d 4f5f 2c2d 2e2d P*2c 3f3e 3d3e 2d2c+ 3a2c 2f2c+ 3b2c P*3f 3e2d 5f5i 6i6h+ 1g1f L*3d N*2h 4d4e 5i5h 6h7g 2g2f 1c1d 2f2e 2d1c 3g4e 5c4d S*4f P*2f 4e5c+ L*4e 4f5g 8e7d P*6e 7d6e P*5f 5d5e 4h3g 5e5f 5g4h P*4f 3g4f 4e4f"
# @sfen = "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f 7a6b 5g5f 8d8e 8h7g"
@sfen = "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f 7a6b 5g5f 8d8e 8h7g 5c5d 2h5h 6b5c 7i6h 5a4b 5i4h 3a3b 4h3h 4c4d 5f5e 3b4c 5e5d 4c5d 6h5g 5d6e 5g5f 6e7f 5f5e 7f6g+ P*5d 5c6b 5h5f 6g7g 8i7g B*3d 5f6f P*5b 6i7i 8b8d"
@page_duration = 2.0
@tick_base = 1000

def fps_option
  "#{@tick_base}/#{(@tick_base * @page_duration).to_i}"
end

def case1
  info = Parser.parse(@sfen)
  container = info.formatter.container_for_image
  screen_image_renderer = ScreenImage.renderer(container, viewpoint: "black")
  list = Magick::ImageList.new
  moves = [nil, *info.pi.move_infos]
  moves.each.with_index do |e, i|
    container.execute(e[:input]) if e
    screen_image_renderer.render
    list.concat([screen_image_renderer.canvas])
  end
  # list = list.coalesce            # 最小単位にしてあったら元のフレームサイズにする
  # list = list.optimize_layers(Magick::OptimizeLayer) # 最小単位にする
  list.delay = 0
  outfile = "_output0.mp4"
  list.write(outfile)
  # `ffmpeg -v warning -hide_banner -r #{fps_option} -i #{outfile} -c:v libx264 -pix_fmt yuv420p -tune stillimage -y _output1_1.mp4`
  `ffmpeg -v warning -hide_banner -r #{fps_option} -i #{outfile} -c:v libx264 -pix_fmt yuv420p -y _output1_1.mp4`
end

def case2
  info = Parser.parse(@sfen)
  container = info.formatter.container_for_image
  screen_image_renderer = ScreenImage.renderer(container, viewpoint: "black")
  moves = [nil, *info.pi.move_infos]
  moves.each.with_index do |e, i|
    container.execute(e[:input]) if e
    screen_image_renderer.render
    screen_image_renderer.canvas.write("_#{i}.png")
  end
  `ffmpeg -v warning -hide_banner -framerate #{fps_option} -i _%d.png -c:v libx264 -pix_fmt yuv420p -y _output1_2.mp4`
end

`rm -f _*`
p Benchmark.ms { case1 }
# p Benchmark.ms { case2 }
puts `ls -alh _output*`
