# frozen-string-literal: true

module Bioshogi
  module Parser
    class SfenParser < Base
      class << self
        def accept?(source)
          source = Parser.source_normalize(source)
          source.match?(/^(?:position|sfen)\b/i) || (source.lines.one? && Sfen.accept?(source))
        end
      end

      def parse
        @sfen = Sfen.parse(normalized_source)
        @mi.move_infos = @sfen.move_infos

        @sfen.piece_counts.each do |location_key, counts|
          location = Location.fetch(location_key)
          name = location.call_name(@sfen.handicap?)
          mi.header["#{name}の持駒"] = Piece.h_to_s(counts)
        end
      end

      def handicap?
        @sfen.handicap?
      end

      def xcontainer_board_setup(xcontainer)
        e = SfenFacade::Setup.new
        e.sfen = @sfen
        e.xcontainer_board_setup(xcontainer)
      end
    end
  end
end
