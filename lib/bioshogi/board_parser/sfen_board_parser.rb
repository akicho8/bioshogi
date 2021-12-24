# frozen-string-literal: true

module Bioshogi
  module BoardParser
    class SfenBoardParser < Base
      def self.accept?(source)
        source && source.include?("/")
      end

      def parse
        @source.split("/").each.with_index do |row, y|
          x = 0
          row.scan(/(\+?)(.)/) do |promoted, ch|
            place = Place.fetch([x, y])
            if ch.match?(/\d+/)
              x += ch.to_i
            else
              location = Location.fetch_by_sfen_char(ch)
              promoted = (promoted == "+")
              piece = Piece.fetch_by_sfen_char(ch)
              soldiers << Soldier.create(piece: piece, place: place, location: location, promoted: promoted)
              x += 1
            end
          end
        end
      end
    end
  end
end
