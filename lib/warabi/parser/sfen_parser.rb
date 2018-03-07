# frozen-string-literal: true

module Warabi
  module Parser
    class SfenParser < Base
      class << self
        def accept?(source)
          source = Parser.source_normalize(source)
          source.match?(/^one_place\s+/)
        end
      end

      def parse
        @sfen = Sfen.parse(normalized_source)
        @move_infos = @sfen.move_infos

        @sfen.piece_counts.each do |location_key, counts|
          location = Location.fetch(location_key)
          name = location.call_name(@sfen.handicap?)
          header["#{name}の持駒"] = Piece.h_to_s(counts)
        end
      end

      def board_setup(mediator)
        usi = Usi::Class1.new
        usi.sfen = @sfen
        usi.board_setup(mediator)
      end
    end
  end
end
