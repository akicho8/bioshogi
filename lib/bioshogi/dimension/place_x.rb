# frozen-string-literal: true

module Bioshogi
  module Dimension
    class PlaceX < Base
      class << self
        # ["1", "2", "3"] -> ["3", "2", "1"].last(2) -> ["2", "1"]
        def char_infos
          @char_infos ||= CharInfo.values.reverse.last(dimension)
        end
      end

      def name
        char_info.number_zenkaku
      end

      def to_sfen
        (self.class.char_infos.size - value).to_s
      end

      # 人間向けの数字で 68 なら 6
      def to_human_int
        self.class.char_infos.size - value
      end
    end
  end
end
