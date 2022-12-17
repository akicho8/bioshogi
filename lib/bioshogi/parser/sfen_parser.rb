# frozen-string-literal: true

module Bioshogi
  module Parser
    class SfenParser < Base
      class << self
        def accept?(source)
          str = Source.wrap(source).to_s
          str.match?(/^(?:position|sfen)\b/i) || (str.lines.one? && Sfen.accept?(str))
        end
      end

      def parse
        @mi.sfen_info = Sfen.parse(normalized_source)
        @mi.move_infos = @mi.sfen_info.move_infos
        @mi.force_handicap = @mi.sfen_info.handicap?

        @mi.sfen_info.piece_counts.each do |location_key, counts|
          location = Location.fetch(location_key)
          name = location.call_name(@mi.sfen_info.handicap?)
          mi.header["#{name}の持駒"] = Piece.h_to_s(counts)
        end
      end
    end
  end
end
