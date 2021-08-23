require "../example_helper"

Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

info = Parser.parse("position startpos moves 7g7f 8c8d")
bin = info.to_animation_gif(one_frame_duration: 0.5, mp4_factory_key: "rmagick", tmpdir_remove: false)
Pathname("_output.gif").write(bin) # => 33719
puts `identify _output.gif`
# `open -a 'Google Chrome' _output.gif`
# >> [mp4_formatter] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210823-13608-ayuyyt
# >> [mp4_formatter] one_frame_duration: 0.5
# >> [mp4_formatter] ticks_per_second: 100
# >> [mp4_formatter] delay: 50
# >> [mp4_formatter] write[begin]: _output1.gif
# >> [mp4_formatter] write[end]: _output1.gif
# >> _output.gif[0] GIF 1200x630 1200x630+0+0 8-bit sRGB 64c 0.000u 0:00.000
# >> _output.gif[1] GIF 62x135 1200x630+446+348 8-bit sRGB 64c 0.000u 0:00.000
# >> _output.gif[2] GIF 113x323 1200x630+384+148 8-bit sRGB 64c 33719B 0.000u 0:00.000
