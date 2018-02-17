require_relative "../../../warabi"

module Warabi
  XtraPattern.define do
    [
      {
        title: Pathname(__FILE__).basename(".*"),
        notation_dsl: lambda do
          board "平手"
          mov "▲７六歩 △８四歩 ▲６八銀 △３四歩 ▲７七銀 △８五歩"
          # snapshot
          auto_flushing {
            push {
              comment "飛車道を塞ぐように銀を上がると大変なことになる"
              mov "▲４八銀 △８六歩 ▲同歩 △同飛"
              push {
                comment "飛車を捨てて角を取って桂香を拾える展開へ"
                mov "▲同銀 △８八角成"
              }
              push {
                comment "そうされては困るので金を上げてみるが…"
                mov "▲７八金 △７七角成 ▲同桂 △８七銀"
              }
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
