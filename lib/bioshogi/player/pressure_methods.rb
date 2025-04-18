# frozen-string-literal: true

module Bioshogi
  class Player
    module PressureMethods
      # 圧力レベル
      def soldiers_pressure_level
        soldiers.sum(&:pressure_level)
      end

      # 圧力レベル(デバッグ用)
      def pressure_report
        rows = []
        rows += soldiers.collect { |e| { "盤上" => e, "勢力" => e.pressure_level } }
        rows += piece_box.collect { |piece_key, count|
          piece = Piece[piece_key]
          {
            "勢力" => "#{piece.standby_level} * #{count}",
            "持駒" => "#{piece}#{count}",
          }
        }
        rows += [{ "勢力" => "合計 #{pressure_level}" }]
        rows += [{ "勢力" => "終盤率 #{pressure_rate}" }]
        rows += [{ "勢力" => "序盤率 #{1.0 - pressure_rate}" }]
        rows
      end

      def pressure_level
        soldiers_pressure_level + piece_box.pressure_level
      end

      def pressure_rate(max = 16)
        pressure_level.clamp(0, max).fdiv(max)
      end
    end
  end
end
