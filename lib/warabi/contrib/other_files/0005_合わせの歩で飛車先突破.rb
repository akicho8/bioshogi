require_relative "../../../warabi"

module Warabi
  XtraPattern.define do
    [
      {
        title: Pathname(__FILE__).basename(".*"),
        dsl: lambda do
          board <<-EOT
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・v桂v香|一
| ・ ・ ・ ・ ・ ・v金v歩 ・|二
| ・ ・ ・ ・ ・v歩v歩 ・v歩|三
| ・ ・ ・ ・ ・ ・ ・ 銀 ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| ・ ・ ・ ・ ・ ・ ・ ・ ・|七
| ・ ・ ・ ・ ・ ・ ・ 飛 ・|八
| ・ ・ ・ ・ ・ ・ ・ 桂 ・|九
+---------------------------+
EOT
          pieces "▲" => "歩"
          auto_flushing {
            mov "▲２三歩"
            mov "△同歩"
            mov "▲同銀成"
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
