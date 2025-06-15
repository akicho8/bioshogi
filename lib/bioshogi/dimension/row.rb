# frozen-string-literal: true

module Bioshogi
  module Dimension
    class Row < Base
      class_attribute :promotable_depth, default: 3 # 相手の陣地の成れる縦幅

      class << self
        def char_infos
          @char_infos ||= CharInfo.take(dimension_size)
        end

        def top
          first
        end

        def bottom
          last
        end

        def middle
          half
        end

        def promotable_depth_set(value)
          self.promotable_depth = value
          cache_clear
        end

        # 一時的に成れない状況にする
        def promotable_disabled(&block)
          save_value = promotable_depth
          promotable_depth_set(0)
          if block_given?
            begin
              yield
            ensure
              promotable_depth_set(save_value)
            end
          else
            save_value
          end
        end
      end

      def name
        char_info.number_kanji
      end

      def to_sfen
        @cache[:to_sfen] ||= ("a".ord + value).chr
      end

      # 人間向けの数字で 68 なら 8
      def to_human_int
        value + 1
      end

      ################################################################################ すべて▲から見た結果を返す

      DELEGATE_METHODS = [
        :distance_from_middle,
        :top_spaces,
        :bottom_spaces,
        :opp_side?,
        :not_opp_side?,
        :own_side?,
        :not_own_side?,
        :middle_row?,
        :funoue_line_ni_uita?,
        :kurai_sasae?,
        :just_nyuugyoku?,
        :atoippo_nyuugyoku?,
        :tarefu_desuka?,
      ]

      # 半分の位置からの距離
      def distance_from_middle
        distance_from_half
      end

      # 自分の側の一番上を0としてあとどれだけで突き当たるかの値 (例えば7段目であれば6を返す)
      def top_spaces
        value
      end

      # 自分の側の一番下を0として底辺までの高さを返す (例えば7段目であれば2を返す)
      # ここはキャッシュしない方が早い
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

      # 4..6段目？
      def middle_row?
        not_own_side? && not_opp_side?
      end

      # 浮き飛車状態？
      def funoue_line_ni_uita?
        bottom_spaces == promotable_depth
      end

      # 位を支える位置(中央の1行下)か？
      # ここらは数字にしてはいけない
      # 「コード上の整数」「将棋の意味での段数」「意味を持つ位置」なのか区別がつかなくなる
      # 位置に意味を持たせた命名にする
      # つまり「6」ではなく「位を支える位置」として命名する
      def kurai_sasae?
        value == (dimension_size / 2 + 1)
      end

      # 玉が初めて入玉した位置か？
      def just_nyuugyoku?
        top_spaces == promotable_depth.pred
      end

      # 玉があと一歩で入玉できる位置か？
      def atoippo_nyuugyoku?
        top_spaces == promotable_depth
      end

      # 垂れ歩状態か？ (つまり2, 3, 4段目)
      def tarefu_desuka?
        top_spaces.between?(1, promotable_depth)
      end

      ################################################################################
    end
  end
end
