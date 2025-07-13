# frozen-string-literal: true

# 方針
# - location 考慮は Place の仕事である
# - location を持ち込んではいけない
# - 常に▲視点のメソッドとする

module Bioshogi
  module Dimension
    class Column < Base
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

      # 人間向けの数字で 68 なら 6
      def human_int
        dimension_size - value
      end

      def to_sfen
        @cache[:to_sfen] ||= human_int.to_s
      end

      ################################################################################ どれも▲から見た結果を返す

      DELEGATE_METHODS = [
        :distance_from_center,

        :left_space,
        :right_space,

        :left_right_space_min,

        :column_eq?,
        :column_is2to8?,
        :column_is2or8?,
        :column_is3to7?,
        :column_is5?,

        :side_edge?,
        :right_edge?,
        :left_edge?,

        :right_side?,
        :left_side?,
        :left_or_right,
        :left_or_right_dir_to_center,
      ]

      ################################################################################

      # 半分の位置からの距離
      def distance_from_center
        distance_from_half
      end

      def left_space
        value
      end

      def right_space
        dimension_size.pred - left_space
      end

      def left_right_space_min
        [left_space, right_space].min
      end

      ################################################################################

      def column_eq?(v)
        human_int == v
      end

      def column_is2to8?
        human_int.in?(2..8)
      end

      def column_is2or8?
        column_eq?(2) || column_eq?(8)
      end

      def column_is3to7?
        human_int.in?(3..7)
      end

      def column_is3or7?
        column_eq?(3) || column_eq?(7)
      end

      def column_is5?
        value == dimension_size / 2
      end

      ################################################################################

      def side_edge?
        left_edge? || right_edge?
      end

      def right_edge?
        value == dimension_size.pred
      end

      def left_edge?
        value == 0
      end

      ################################################################################

      def right_side?
        value > dimension_size / 2
      end

      def left_side?
        value < dimension_size / 2
      end

      def left_or_right
        case
        when right_side?
          :right
        when left_side?
          :left
        else
          nil
        end
      end

      def left_or_right_dir_to_center
        if v = left_or_right
          v == :right ? :left : :right
        end
      end

      ################################################################################
    end
  end
end
