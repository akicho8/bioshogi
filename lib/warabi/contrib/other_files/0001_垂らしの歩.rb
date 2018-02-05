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
| ・ ・ ・ ・ ・v銀v金v角 ・|二
| ・ ・ ・ ・ ・v歩v歩 ・v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| ・ ・ ・ ・ ・ ・ 歩 ・ 歩|七
| ・ ・ ・ ・ ・ ・ ・ 飛 ・|八
| ・ ・ ・ ・ ・ ・ ・ 桂 香|九
+---------------------------+
BOARD
          pieces "▲" => "歩1"
          auto_flushing {
            push {
              comment "成功するパターン"
              mov "▲２四歩"
              mov "△３一角"
              mov "▲２三歩成"
            }
            push {
              comment "最初に戻って失敗するパターン"
              mov "▲２三歩"
              mov "△３一角"
              mov "▲２二歩成"
              mov "△２二角"
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
