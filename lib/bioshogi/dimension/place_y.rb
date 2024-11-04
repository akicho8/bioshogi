# frozen-string-literal: true

module Bioshogi
  module Dimension
    class PlaceY < Base
      cattr_accessor(:promotable_depth) { 3 }      # 相手の陣地の成れる縦幅

      DELEGATE_METHODS = [
        :top_spaces,
        :bottom_spaces,
        :opp_side?,
        :not_opp_side?,
        :own_side?,
        :not_own_side?,
        :kurai_sasae?,
      ]

      class << self
        def char_infos
          @char_infos ||= CharInfo.take(dimension)
        end

        # 一時的に成れない状況にする
        def promotable_disabled(&block)
          old_value = promotable_depth
          PlaceY.promotable_depth = 0
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

      ################################################################################

      # 成れるか？
      # @example
      #   Place.fetch("１三").opp_side?(:black) # => true
      #   Place.fetch("１四").opp_side?(:black) # => false
      # def opp_side?(location)
      #   v = self
      #   if location.white?
      #     v = v.flip
      #   end
      #   if promotable_depth
      #     v.value < promotable_depth
      #   end
      # end

      # 自分の側の一番上を0としてあとどれだけで突き当たるかの値 (例えば7段目であれば6を返す)
      def top_spaces(location)
        white_then_flip(location).value
      end

      # 自分の側の一番下を0として底辺までの高さを返す (例えば7段目であれば2を返す)
      def bottom_spaces(location)
        dimension - 1 - top_spaces(location)
      end

      # 相手の陣地にいる？
      def opp_side?(location)
        top_spaces(location) < promotable_depth
      end

      # 相手の陣地に入ってない？
      def not_opp_side?(location)
        !opp_side?(location)
      end

      # 自分の陣地にいる？
      def own_side?(location)
        bottom_spaces(location) < promotable_depth
      end

      # 自分の陣地にいない？
      def not_own_side?(location)
        !own_side?(location)
      end

      # 中央のすぐ下にいる？ (位の歩を支える銀の位置で▲なら6段目で△なら4段目ならtrue)
      def kurai_sasae?(location)
        value == (dimension / 2 + location.sign_dir)
      end
    end
  end
end
