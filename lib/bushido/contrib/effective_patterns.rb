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
  ]

  if $0 == __FILE__
    frame = LiveFrame2.new(EffectivePatterns.first)
    frame.to_all_frames.each{|f|
      p f
    }
  end
end
