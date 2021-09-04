require "../example_helper"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
Parser.parse("position startpos moves 7g7f 3c3d").to_mp4
