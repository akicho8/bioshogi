module Bioshogi
  class Soldier
    # 手筋判定用
    concern :TechniqueMatcherMethods do
      Place::DELEGATE_METHODS.each do |name|
        define_method(name) do |*args, **options|
          place.public_send(name, location, *args, **options)
        end
      end

      ################################################################################

      # 自玉の位置にいる？
      def initial_place?
        column_is_center? && bottom_spaces == 0
      end

      # 前に一直線に進めるタイプか？
      def maeni_ittyokusen?
        (piece.key == :lance && normal?) || piece.key == :rook
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
# ~> -:4:in `<class:Soldier>': undefined method `concern' for Bioshogi::Soldier:Class (NoMethodError)
# ~> 	from -:2:in `<module:Bioshogi>'
# ~> 	from -:1:in `<main>'
