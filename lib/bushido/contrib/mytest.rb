# -*- coding: utf-8; compile-command: "be ruby mytest.rb" -*-

require_relative "../../bushido"

module Bushido
  Mytest = [
    {
      :title => "(title)",
      :comment => "(comment)",
      :pieces => {:black => ""},
      :execute => "
*comment1
▲３二銀
*comment2
▲同銀
*comment3
",
      :board => <<-EOT
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・ ・|一
| ・ ・ ・ ・ ・ ・v銀 ・ ・|二
| ・ ・ ・ ・ ・ ・ 銀 ・ ・|三
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
    mediator = Sequencer.new(Mytest.last)
    mediator.to_all_frames{|f|
      p f
      p f.human_kif_logs
    }
    p mediator
    p mediator.human_kif_logs
  end
end
