# -*- coding: utf-8 -*-
module Bushido
  module KifFormat
    module Soldier
      extend ActiveSupport::Concern

      included do
      end

      module ClassMethods
      end

      def to_kif_name
        "#{@player.location == :white ? 'v' : ' '}#{piece_current_name}"
      end
    end

    module Field
      extend ActiveSupport::Concern

      included do
      end

      module ClassMethods
      end

      # kif形式詳細 (1) - 勝手に将棋トピックス http://d.hatena.ne.jp/mozuyama/20030909/p5
      #
      #   ９ ８ ７ ６ ５ ４ ３ ２ １
      # +---------------------------+
      # | ・v桂v銀v金v玉v金v銀v桂v香|一
      # | ・v飛 ・ ・ ・ ・ ・v角 ・|二
      # |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
      # | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
      # | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
      # | 香 桂 銀 金 玉 金 銀 桂 香|九
      # +---------------------------+
      def to_kif_table
        rows = Position::Vpos.units.size.times.collect{|y|
          values = Position::Hpos.units.size.times.collect{|x|
            if soldier = @matrix[[x, y]]
              soldier.to_kif_name
            else
              " " + "・"
            end
          }
          "|" + values.join + "|" + Position::Vpos.parse(y).name
        }
        s = []
        s << "  " + Position::Hpos.zenkaku_units.join(" ")
        s << "+---------------------------+"
        s += rows
        s << "+---------------------------+"
        s.collect{|e|e + "\n"}.join
      end
    end
  end
end
