require "../setup"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
sfen = "position startpos moves 7g7f"
info = Parser.parse(sfen)
bin = info.to_animation_mp4(cover_text: "なんとか将棋大会\n☗先手 vs ☖後手\n2021-09-12")
Pathname("_output.mp4").write(bin)
`open _output.mp4`
