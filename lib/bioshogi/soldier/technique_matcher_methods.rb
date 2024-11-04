module Bioshogi
  class Soldier
    # 手筋判定用
    concern :TechniqueMatcherMethods do
      ################################################################################ location を考慮した place へのショートカット (X)

      def left_spaces
        place.left_spaces(location)
      end

      def right_spaces
        place.right_spaces(location)
      end

      delegate *Dimension::PlaceX::DELEGATE_METHODS_NO_ARGS, to: :place

      ################################################################################ location を考慮した place へのショートカット (Y)

      def top_spaces
        place.top_spaces(location)
      end

      def bottom_spaces
        place.bottom_spaces(location)
      end

      def opp_side?
        place.opp_side?(location)
      end

      def not_opp_side?
        place.not_opp_side?(location)
      end

      def own_side?
        place.own_side?(location)
      end

      def not_own_side?
        place.not_own_side?(location)
      end

      def kurai_sasae?
        place.kurai_sasae?(location)
      end

      ################################################################################

      def move_to_bottom
        place.move_to_bottom(location)
      end

      def move_to_top
        place.move_to_top(location)
      end

      def move_to_left
        place.move_to_left(location)
      end

      def move_to_right
        place.move_to_right(location)
      end

      ################################################################################

      # 上下左右 -1 +1 -1 +1 に進んだ位置を返す (white側の場合も考慮する)
      # 2つ進んだ位置などを一発で調べたいときに使う
      def move_to_xy(x, y)
        place.move_to_xy(location, x, y)
      end

      # より抽象的な方法で移動した位置を返す
      def move_to(vector)
        place.move_to(location, vector)
      end

      ################################################################################

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
        Dimension::PlaceX.dimension.pred - place.x.value
      end

      # センターにいる？ (5の列にいる？)
      def x_is_center?
        place.x_is_center?
      end

      # 自玉の位置にいる？
      def initial_place?
        x_is_center? && bottom_spaces == 0
      end

      # 垂れ歩状態か？ (つまり2, 3, 4段目)
      def tarehu_ikeru?
        top_spaces.between?(1, Dimension::PlaceY.promotable_depth)
      end

      # 前に一直線に進めるタイプか？
      def maeni_ittyokusen?
        (piece.key == :lance && !promoted) || piece.key == :rook
      end

      ################################################################################

      # 駒の重さ(=価値) 常にプラス
      def abs_weight
        piece.any_weight(promoted)
      end

      # 駒の重さ(=価値)。先手視点。後手ならマイナスになる
      def relative_weight
        abs_weight * location.sign_dir
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
