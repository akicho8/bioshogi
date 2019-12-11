# frozen-string-literal: true
# bioshogi piece

if $0 == __FILE__
  require "../cli"
end

module Bioshogi
  class Cli
    desc "piece", "駒一覧"
    def piece
      tp Piece.collect(&:to_h)
    end
  end
end

if $0 == __FILE__
  Bioshogi::Cli.start(["piece"])
end
