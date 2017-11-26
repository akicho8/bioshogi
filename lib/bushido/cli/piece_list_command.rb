# -*- compile-command: "ruby base.rb piece_list" -*-
# frozen-string-literal: true

module Bushido
  module Cli
    class PieceListCommand < Base
      self.command_name = "駒情報一覧"

      def execute
        tp Piece.collect(&:attributes)
      end
    end
  end
end
