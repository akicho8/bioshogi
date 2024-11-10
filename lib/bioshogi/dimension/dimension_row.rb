# frozen-string-literal: true

module Bioshogi
  module Dimension
    class DimensionRow < Base
      cattr_accessor(:promotable_depth) { 3 }      # 相手の陣地の成れる縦幅

      class << self
        def char_infos
          @char_infos ||= CharInfo.take(dimension_size)
        end

        def top
          fetch(0)
        end

        def bottom
          fetch(dimension_size.pred)
        end

        # 一時的に成れない状況にする
        def promotable_disabled(&block)
          old_value = promotable_depth
          DimensionRow.promotable_depth = 0
          if block_given?
            begin
              yield
            ensure
              self.promotable_depth = old_value
            end
          else
            old_value
          end
        end
      end

      def name
        char_info.number_kanji
      end

      def to_sfen
        ("a".ord + value).chr
      end

      # 人間向けの数字で 68 なら 8
      def to_human_int
        value + 1
      end

      ################################################################################ すべて▲から見た結果を返す

      DELEGATE_METHODS = [
        :top_spaces,
        :bottom_spaces,
        :opp_side?,
        :not_opp_side?,
        :own_side?,
        :not_own_side?,
        :kurai_sasae?,
        :sandanme?,
        :yondanme?,
      ]

      # 自分の側の一番上を0としてあとどれだけで突き当たるかの値 (例えば7段目であれば6を返す)
      def top_spaces
        value
      end

      # 自分の側の一番下を0として底辺までの高さを返す (例えば7段目であれば2を返す)
      def bottom_spaces
        dimension_size.pred - top_spaces
      end

      # 相手の陣地にいる？
      def opp_side?
        top_spaces < promotable_depth
      end

      # 相手の陣地に入ってない？
      def not_opp_side?
        !opp_side?
      end

      # 自分の陣地にいる？
      def own_side?
        bottom_spaces < promotable_depth
      end

      # 自分の陣地にいない？
      def not_own_side?
        !own_side?
      end

      # 中央のすぐ下にいる？ (位の歩を支える銀の位置で▲なら6段目で△なら4段目ならtrue)
      def kurai_sasae?
        value == (dimension_size / 2 + 1)
      end

      # 玉が初めて入玉した位置か？
      def sandanme?
        top_spaces == promotable_depth.pred
      end

      # 玉があと一歩で入玉できる位置か？
      def yondanme?
        top_spaces == promotable_depth
      end

      ################################################################################
    end
  end
end
