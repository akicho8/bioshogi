$LOAD_PATH.unshift(File.expand_path("..", __dir__))

require "bioshogi"
require "thor"

module Bioshogi
  class CLI < Thor
    include Converter::CLI
    include AI::Versus::CLI
    include InputParser::CLI
    include Piece::CLI
  end
end

if $0 == __FILE__
  Bioshogi::CLI.start
end
