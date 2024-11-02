module Bioshogi
  class Soldier
    # 手筋判定用
    concern :TechniqueMatcherMethods do
      # 自分の側の一番上を0としてあとどれだけで突き当たるかの値
      def top_spaces
        place.top_spaces(location)
      end

      # 自分の側の一番下を0としてどれだけ前に進んでいるかを返す
      def bottom_spaces
        place.bottom_spaces(location)
      end

      # 自分の陣地にいる？
      def own_side?
        place.own_side?(location)
      end

      # 相手の陣地にいる？
      def opponent_side?
        place.opponent_side?(location)
      end

      # 「左右の壁からどれだけ離れているかの値」の小さい方(先後関係なし)
      def smaller_one_of_side_spaces
        [place.x.value, __distance_from_right].min
      end

      # 左右の壁に近い方に進むときの符号(先手視点なので先後関係なし)
      def sign_to_goto_closer_side
        if place.x.value > __distance_from_right
          1
        else
          -1
        end
      end

      # 先手から見て右からの距離
      def __distance_from_right
        Dimension::PlaceX.dimension - 1 - place.x.value
      end

      # センターにいる？ (5の列にいる？)
      def center_place?
        place.x.value == Dimension::PlaceX.dimension / 2
      end

      # 自玉の位置にいる？
      def initial_place?
        center_place? && bottom_spaces == 0
      end

      # 駒の重さ(=価値) 常にプラス
      def abs_weight
        piece.any_weight(promoted)
      end

      # 駒の重さ(=価値)。先手視点。後手ならマイナスになる
      def relative_weight
        abs_weight * location.value_sign
      end

      # 敵への駒の圧力(終盤度)
      def pressure_level(area = 4)
        case
        when top_spaces < area
          if promoted
            piece.promoted_attack_level
          else
            piece.attack_level
          end
        when bottom_spaces < area
          if promoted
            -piece.promoted_defense_level
          else
            -piece.defense_level
          end
        else
          0
        end
      end
    end
  end
end
