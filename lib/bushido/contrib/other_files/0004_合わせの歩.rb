# -*- coding: utf-8 -*-

require_relative "../../../bushido"

module Bushido
  XtraPattern.define do
    [
      {
        :title => Pathname(__FILE__).basename(".*"),
        :dsl => lambda do
          board <<-BOARD
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・v桂v香|一
| ・ ・ ・ ・ ・ ・v金v玉 ・|二
| ・ ・ ・ ・ ・v歩v歩v歩v歩|三
| ・ ・ ・ ・v銀 ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ 歩 ・ 歩|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| ・ ・ ・ ・ ・ ・ ・ ・ ・|七
| ・ ・ ・ ・ ・ ・ ・ 飛 ・|八
| ・ ・ ・ ・ ・ ・ ・ 桂 香|九
+---------------------------+
BOARD
          pieces "先手" => "歩"
          auto_flushing {
            comment "横の銀を狙って合わせの歩"
            mov "▲２四歩"
            push {
              comment "取ってくれた場合"
              mov "△同歩"
              mov "▲同飛"
              mov "△２三歩"
              mov "▲５四飛"
            }
            push {
              comment "察知して銀に逃げられた場合"
              mov "△６三銀"
              mov "▲２三歩成"
              mov "△同金"
              mov "▲２四歩"
            }
          }
        end,
      },
    ]
  end

  if $0 == __FILE__
    # XtraPattern.each{|pattern|HybridSequencer.execute(pattern)}
    HybridSequencer.execute(XtraPattern.list.last).each{|frame|
      puts frame.to_text
    }
  end
end
