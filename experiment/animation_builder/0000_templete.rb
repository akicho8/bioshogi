require "../example_helper"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
sfen = "position startpos moves 7g7f"
info = Parser.parse(sfen)
bin = info.to_mp4({width: 1000, height: 200, cover_text: "あいう\nえお"})
Pathname("_output.mp4").write(bin)
`open _output.mp4`
