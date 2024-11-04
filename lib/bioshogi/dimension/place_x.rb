# frozen-string-literal: true

module Bioshogi
  module Dimension
    class PlaceX < Base
      # ▲から見て2筋と8筋
      SIDE_PLUS_1   = 1                                                                # 2筋と8筋は左右から「1」つ内側にある
      ARRAY_2_8     = [SIDE_PLUS_1, dimension - 1 - SIDE_PLUS_1] # [2, 8]
      SET_2_8       = ARRAY_2_8.to_set                                                 # #<Set: {2, 3}>
      RANGE_2_8     = Range.new(*ARRAY_2_8)                                            # 2..8

      # ▲から見て3筋と7筋
      SIDE_PLUS_2   = 2                                                                # 3筋と7筋は左右から「2」つ内側にある
      ARRAY_3_7     = [SIDE_PLUS_2, dimension - 1 - SIDE_PLUS_2] # [3, 7]
      SET_3_7       = ARRAY_3_7.to_set                                                 # #<Set: {3, 3}>
      RANGE_3_7     = Range.new(*ARRAY_3_7)                                            # 3..7

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

      # 2から8筋か？
      def in_two_to_eight?
        RANGE_2_8.cover?(value)
      end

      # 2または8筋か？
      def in_two_or_eight?
        SET_2_8.include?(value)
      end

      # 3から7筋か？
      def in_three_to_seven?
        RANGE_3_7.cover?(value)
      end

      # センターにいる？ (5の列にいる？)
      def center_place?
        value == dimension / 2
      end

      # 端？
      def begin_or_end?
        value == 0 || value == dimension.pred
      end
    end
  end
end
