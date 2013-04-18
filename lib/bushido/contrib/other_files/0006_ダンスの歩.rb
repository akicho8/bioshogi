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
| ・ ・ ・ ・ ・v銀v金 ・ ・|二
| ・ ・ ・v歩 ・v金 ・v歩 ・|三
| ・ ・ ・ ・ ・ ・ 歩 ・v歩|四
| ・ ・ ・ 歩 ・ 銀 ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ 歩|六
| ・ ・ ・ ・ ・ ・ ・ ・ ・|七
| ・ ・ ・ ・ ・ ・ ・ 飛 ・|八
| ・ ・ ・ ・ ・ ・ ・ 桂 香|九
+---------------------------+
BOARD
          pieces "先手" => "歩3"
          auto_flushing {
            mov "▲４四歩"
            mov "△５三金"
            mov "▲５四歩"
            mov "△５二金"
            mov "▲４三歩成"
            push {
              comment "銀で取った場合"
              mov "△４三銀"
              mov "▲４四歩"
            }
            push {
              comment "金で取った場合"
              mov "△４三金右"
              mov "▲４四歩"
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
