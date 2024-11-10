# frozen-string-literal: true

# 方針
# - location 考慮は Place の仕事である
# - location を持ち込んではいけない
# - 常に▲視点のメソッドとする

module Bioshogi
  module Dimension
    class DimensionColumn < Base
      # ▲から見て2筋と8筋
      SIDE_PLUS_1   = 1                                                                # 2筋と8筋は左右から「1」つ内側にある
      ARRAY_2_8     = [SIDE_PLUS_1, dimension_size.pred - SIDE_PLUS_1] # [2, 8]
      SET_2_8       = ARRAY_2_8.to_set                                                 # #<Set: {2, 3}>
      RANGE_2_8     = Range.new(*ARRAY_2_8)                                            # 2..8

      # ▲から見て3筋と7筋
      SIDE_PLUS_2   = 2                                                                # 3筋と7筋は左右から「2」つ内側にある
      ARRAY_3_7     = [SIDE_PLUS_2, dimension_size.pred - SIDE_PLUS_2] # [3, 7]
      SET_3_7       = ARRAY_3_7.to_set                                                 # #<Set: {3, 3}>
      RANGE_3_7     = Range.new(*ARRAY_3_7)                                            # 3..7

      class << self
        # ["1", "2", "3"] -> ["3", "2", "1"].last(2) -> ["2", "1"]
        def char_infos
          @char_infos ||= CharInfo.values.reverse.last(dimension_size)
        end

        def left
          fetch(0)
        end

        def right
          fetch(dimension_size.pred)
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

      ################################################################################ どれも▲から見た結果を返す

      DELEGATE_METHODS = [
        :left_spaces,
        :right_spaces,

        :column_is_two_to_eight?,
        :column_is_two_or_eight?,
        :column_is_three_to_seven?,
        :column_is_center?,
        :column_is_edge?,

        :column_is_right_area?,
        :column_is_left_area?,
        :column_is_right_edge?,
        :column_is_left_edge?,
      ]

      # location から見て左方向の余白
      def left_spaces
        value
      end

      # location から見て右方向の余白
      def right_spaces
        dimension_size.pred - left_spaces
      end

      # 2から8筋か？
      def column_is_two_to_eight?
        RANGE_2_8.cover?(value)
      end

      # 2または8筋か？
      def column_is_two_or_eight?
        SET_2_8.include?(value)
      end

      # 3から7筋か？
      def column_is_three_to_seven?
        RANGE_3_7.cover?(value)
      end

      # センターにいる？ (5の列にいる？)
      def column_is_center?
        value == dimension_size / 2
      end

      # 端？
      def column_is_edge?
        column_is_left_edge? || column_is_right_edge?
      end

      # 右側か？
      def column_is_right_area?
        value > dimension_size / 2
      end

      # 左側か？
      def column_is_left_area?
        value < dimension_size / 2
      end

      # 右端か？
      def column_is_right_edge?
        value == dimension_size.pred
      end

      # 左端か？
      def column_is_left_edge?
        value == 0
      end

      ################################################################################
    end
  end
end
