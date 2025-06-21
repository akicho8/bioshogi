# frozen-string-literal: true

# 方針
# - location 考慮は Place の仕事である
# - location を持ち込んではいけない
# - 常に▲視点のメソッドとする

module Bioshogi
  module Dimension
    class Column < Base
      ONE_COLUMN = 1

      class << self
        # ["1", "2", "3"] -> ["3", "2", "1"].last(2) -> ["2", "1"]
        def char_infos
          @char_infos ||= CharInfo.values.reverse.last(dimension_size)
        end

        def left
          first
        end

        def right
          last
        end

        def center
          half
        end
      end

      def name
        char_info.number_zenkaku
      end

      # キャッシュ効果あり
      def to_sfen
        @cache[:to_sfen] ||= (dimension_size - value).to_s
      end

      # 人間向けの数字で 68 なら 6
      def to_human_int
        dimension_size - value
      end

      ################################################################################ どれも▲から見た結果を返す

      DELEGATE_METHODS = [
        :distance_from_center,
        :left_spaces,
        :right_spaces,

        :column_spaces_min,
        :align_arrow,

        :column_is_second_to_eighth?,
        :column_is_second_or_eighth?,
        :column_is_three_to_seven?,
        :column_is_center?,
        :column_is_edge?,

        :column_is_right_side?,
        :column_is_left_side?,
        :column_is_right_edge?,
        :column_is_left_edge?,
      ]

      # 半分の位置からの距離
      def distance_from_center
        distance_from_half
      end

      # location から見て左方向の余白
      def left_spaces
        value
      end

      # location から見て右方向の余白
      def right_spaces
        dimension_size.pred - left_spaces
      end

      # left_spaces とright_spaces の小さい方
      def column_spaces_min
        [left_spaces, right_spaces].min
      end

      # 寄っている方向
      def align_arrow
        column_is_right_side? ? :right : :left
      end

      # 2から8筋か？
      def column_is_second_to_eighth?
        ONE_COLUMN <= value && value <= dimension_size.pred - ONE_COLUMN
      end

      # 2または8筋か？
      def column_is_second_or_eighth?
        value == ONE_COLUMN || value == dimension_size.pred - ONE_COLUMN
      end

      # 3から7筋か？
      def column_is_three_to_seven?
        ONE_COLUMN < value && value < dimension_size.pred - ONE_COLUMN
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
      def column_is_right_side?
        value > dimension_size / 2
      end

      # 左側か？
      def column_is_left_side?
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
