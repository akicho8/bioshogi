# -*- coding: utf-8 -*-

require_relative "../../bushido"

module Bushido
  EffectivePatterns = [
    {
      :title => "桂と金の交換または桂成(おじいちゃんがよく使っていた技)",
      :comment => "金が逃げても３二桂成を防げない",
      :pieces => {:black => "桂"},
      :execute => "▲２四桂 △２三金 ▲３二桂成",
      :board => <<-EOT
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・ ・|一
| ・ ・ ・ ・ ・ ・ ・v銀v金|二
| ・ ・ ・ ・ ・ ・ ・ ・ ・|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| ・ ・ ・ ・ ・ ・ ・ ・ ・|七
| ・ ・ ・ ・ ・ ・ ・ ・ ・|八
| ・ ・ ・ ・ ・ ・ ・ ・ ・|九
+---------------------------+
EOT
    },
    {
      :title => "早囲い",
      :comment => "3手で組める",
      :execute => "▲４八玉 ▲３八玉 ▲４八銀",
      :board => :black,
    },
    {
      :title => "ミレニアム囲い(別名カマクラ・カマボコ・トーチカ)",
      :comment => "藤井システムに対抗する囲い",
      :execute => "▲７六歩 ▲２六歩 ▲２五歩 ▲４八銀 ▲６八玉 ▲７八玉 ▲５六歩 ▲９六歩 ▲５八金右 ▲３六歩 ▲６六角 ▲８八銀 ▲７七桂 ▲６八金寄 ▲８九玉 ▲７九金 ▲７八金寄 ▲５九銀 ▲６八銀",
      :board => :black,
    },
  ]

  if $0 == __FILE__
    frame = LiveFrame2.new(EffectivePatterns.last)
    frame.to_all_frames.each{|f|
      p f
    }
  end
end
