require "../setup"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
sfen = "position startpos moves 7g7f"
info = Parser.parse(sfen)
bin = info.to_animation_mp4({ tmpdir_remove: false, audio_part_a: "#{__dir__}/image_included.mp3" })
Pathname("_output.mp4").write(bin) # => 363897
`open -a 'Google Chrome' _output.mp4`
