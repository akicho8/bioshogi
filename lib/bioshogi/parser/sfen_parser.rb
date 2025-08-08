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
        @pi.sfen_info      = Sfen.parse(normalized_source)
        @pi.move_infos     = @pi.sfen_info.move_infos
        @pi.force_handicap = @pi.sfen_info.handicap?
        # @pi.force_preset_info = @pi.sfen_info.handicap?

        @pi.sfen_info.piece_counts.each do |location_key, counts|
          location = Location.fetch(location_key)
          name = location.call_name(@pi.sfen_info.handicap?)
          @pi.header["#{name}の持駒"] = Piece.h_to_s(counts)
        end
      end
    end
  end
end
