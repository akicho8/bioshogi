# frozen-string-literal: true

module Bioshogi
  module Yomiage
    class Formatter < OfficialFormatter
      def str_compact(str)
        str
      end

      def location_name
        location.yomiage(handicap) + "、"
      end

      def piece_name
        piece.yomiage(false)
      end

      def place_name
        place_to.yomiage
      end

      def soldier_name
        soldier.yomiage
      end

      def kw(s)
        KanjiInfo.fetch(s).yomiage
      end
    end
  end
end
