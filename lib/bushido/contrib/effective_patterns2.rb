# -*- coding: utf-8; compile-command: "be ruby effective_patterns2.rb" -*-

require_relative "../../bushido"

module Bushido
  EffectivePatterns2 = [
    {
      :title => "付き捨て+タタキ+合わせ",
      :dsl => KifuDsl.define do
        # title "(title)"
        # comment "(comment)"
        board <<-BOARD
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・v桂v香|一
| ・ ・ ・ ・ ・ ・v金 ・ ・|二
| ・ ・ ・ ・ ・v歩 ・v歩 ・|三
| ・ ・ ・ ・ ・ ・v歩 ・v歩|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ 歩 ・ 歩|六
| ・ ・ ・ ・ ・ 歩 ・ ・ ・|七
| ・ ・ ・ ・ ・ ・ ・ 飛 ・|八
| ・ ・ ・ ・ ・ ・ ・ 桂 香|九
+---------------------------+
BOARD
        pieces "先手" => "歩4"
        mov "▲１五歩"
        mov "△同歩"
        push {
          mov "▲１二歩"
          mov "△同香"
          mov "▲１三歩"
          mov "△同香"
          mov "▲１四歩"
          mov "△同香"
          mov "▲２四歩"
          mov "△同歩"
          mov "▲同飛"
          mov "△２三歩"
          mov "▲１四飛"
          disp "香車ゲット"
        }
        mov "▲１三歩"
        mov "△同桂"
        mov "▲１二歩"
        mov "△同香"
        mov "▲１四歩"
        mov "▲１五香"
        mov "▲１三歩成"
        mov "△１三香"
        mov "▲１三香成"
        disp "桂馬と香車とゲット"
      end
    },
  ]

  if $0 == __FILE__
    sequencer = Sequencer.new
    sequencer.pattern = EffectivePatterns2.last[:dsl]
    sequencer.evaluate
    p sequencer.frames

    # loop do
    #   r = sequencer.eval_step
    #   if r.nil?
    #     break
    #   end
    #   p sequencer.kif_logs.last.to_s_human
    #   p sequencer
    #   p sequencer.variables
    # end

    # mediator = SimulatorFrame.new(EffectivePatterns.last)
    # mediator.to_all_frames{|f|
    #   p f
    #   p f.human_kif_logs
    # }
    # p mediator
    # p mediator.human_kif_logs
  end
end
