# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/kif_format_spec.rb" -*-

module Bushido
  module KifFormat
    class Parser < BaseFormat::Parser
      def self.resolved?(source)
        source = normalized_source(source)
        source.match(/^手数.*指手.*消費時間.*$/) && !source.match(/^変化：/)
      end

      # | # ----  Kifu for Windows V6.26 棋譜ファイル  ----
      # | key：value
      # | 手数----指手---------消費時間--
      # | *コメント0
      # |    1 ７六歩(77)   ( 0:00/00:00:00)
      def parse
        @_head, @_body = @source.split(/^手数.*指手.*消費時間.*$/, 2)
        read_header
        @_body.lines.each do |line|
          comment_read(line)
          if md = line.match(/^\s+(?<index>\d+)\s+(?<input>\S.*?)\s+\(\s*(?<spent_time>.*)\)/)
            @move_infos << {:index => md[:index], :input => md[:input], :spent_time => md[:spent_time]}
          end
        end
      end
    end

    module Soldier
      def to_s_kakiki
        "#{@player.location == :white ? 'v' : ' '}#{piece_current_name}"
      end
    end

    module Board
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
      def to_s_kakiki
        rows = Position::Vpos.units.size.times.collect{|y|
          values = Position::Hpos.units.size.times.collect{|x|
            if soldier = @matrix[[x, y]]
              soldier.to_s(:kakiki)
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
