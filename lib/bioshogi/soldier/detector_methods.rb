module Bioshogi
  class Soldier
    # 手筋判定用
    concern :DetectorMethods do
      Place::DELEGATE_METHODS_WITH_LOCATION.each do |name|
        define_method(name) do |*args, **options|
          place.public_send(name, location, *args, **options)
        end
      end

      delegate *Place::DIRECT_DELEGATE_METHODS, to: :place

      ################################################################################

      # 後手は先手目線として計算する
      #
      #   Soldier.from_str("▲55玉").vector_from(Soldier.from_str("▲56玉")) == V.up
      #   Soldier.from_str("▲55玉").vector_from(Soldier.from_str("▲54玉")) == V.down
      #   Soldier.from_str("▲55玉").vector_from(Soldier.from_str("▲45玉")) == V.left
      #   Soldier.from_str("▲55玉").vector_from(Soldier.from_str("▲65玉")) == V.right
      #
      #   Soldier.from_str("△55玉").vector_from(Soldier.from_str("△56玉")) == V.down
      #   Soldier.from_str("△55玉").vector_from(Soldier.from_str("△54玉")) == V.up
      #   Soldier.from_str("△55玉").vector_from(Soldier.from_str("△45玉")) == V.right
      #   Soldier.from_str("△55玉").vector_from(Soldier.from_str("△65玉")) == V.left
      def vector_from(from)
        white_then_flip.place.vector_from(from.white_then_flip.place)
      end

      def vector_to(to)
        white_then_flip.place.vector_to(to.white_then_flip.place)
      end

      # a から b を見たとき b は左右どちらにいるか？
      # relative_move_to に渡せる抽象化した向きを返す
      # def left_or_light_from_a_to_b(a, b)
      #   v1 = a.white_then_flip.place.column.value
      #   v2 = b.white_then_flip.place.column.value
      #   case
      #   when v1 < v2
      #     :left
      #   when v1 > v2
      #     :right
      #   end
      # end

      ################################################################################

      # 前に一直線に進めるタイプか？
      def boar_mode?
        (piece.key == :lance && normal?) || piece.key == :rook
      end

      ################################################################################ for SoldierLookupTableMethods

      def to_key1
        :"#{location.key}/#{piece.key}"
      end

      def to_key2
        :"#{location.key}/#{piece.key}/#{promoted}"
      end

      ################################################################################ for XmotionAnalyzer, MotionAnalyzer

      def motion_key(drop_hand)
        [piece.key, promoted, !!drop_hand]
      end

      ################################################################################ for BoardPieceCountsMethods

      # def location_with_piece
      #   [location.key, piece.key]
      # end

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
