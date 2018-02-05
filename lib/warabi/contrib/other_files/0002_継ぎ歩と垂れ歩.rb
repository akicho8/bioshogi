require_relative "../../../warabi"

module Warabi
  XtraPattern.define do
    [
      {
        title: Pathname(__FILE__).basename(".*"),
        dsl: lambda do
          board <<-BOARD
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・v桂v香|一
| ・ ・ ・ ・ ・v銀v玉v角 ・|二
| ・ ・ ・ ・ ・v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| ・ ・ ・ ・ ・ ・ 歩 ・ 歩|七
| ・ ・ ・ ・ ・ ・ ・ 飛 ・|八
| ・ ・ ・ ・ ・ ・ ・ 桂 香|九
+---------------------------+
BOARD
          pieces "▲" => "歩3"
          auto_flushing {
            push {
              mov "▲２四歩"
              mov "△同歩"
              mov "▲２五歩"
              mov "△同歩"
              mov "▲２四歩"
              mov "△３四歩"
              mov "▲２五飛"
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
