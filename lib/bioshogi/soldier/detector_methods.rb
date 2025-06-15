module Bioshogi
  class Soldier
    # 手筋判定用
    concern :DetectorMethods do
      Place::DELEGATE_METHODS.each do |name|
        define_method(name) do |*args, **options|
          place.public_send(name, location, *args, **options)
        end
      end

      ################################################################################

      # 前に一直線に進めるタイプか？
      def boar_mode?
        (piece.key == :lance && normal?) || piece.key == :rook
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
