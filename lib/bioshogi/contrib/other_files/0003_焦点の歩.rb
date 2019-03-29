require_relative "../../../bioshogi"

module Bioshogi
  XtraPattern.define do
    [
      {
        title: Pathname(__FILE__).basename(".*"),
        notation_dsl: lambda do
          board <<-EOT
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・v桂v香|一
| ・ ・ ・ ・ ・v角v金v玉 ・|二
| ・ ・ ・ ・ ・v金v銀v歩v歩|三
| ・ ・ ・ ・ ・v歩 ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ 歩 ・|五
| ・ ・ ・ ・ ・ 歩 銀 ・ ・|六
| ・ ・ ・ ・ ・ ・ ・ ・ 歩|七
| ・ ・ ・ ・ ・ ・ ・ 飛 ・|八
| ・ ・ ・ ・ ・ ・ ・ 桂 香|九
+---------------------------+
EOT
          pieces "▲" => "歩2"
          auto_flushing {
            comment "銀なら真っ直ぐ、金なら斜めに誘き出す"
            mov "▲３四歩"
            push {
              comment "銀で取ると"
              mov "△同銀"
              comment "下がれない"
              mov "▲３五歩"
            }
            push {
              comment "金で取っても"
              mov "△同金"
              comment "下がれない"
              mov "▲３五歩"
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
