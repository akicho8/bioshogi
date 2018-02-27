require "./example_helper"

log_file = "00100_debug.txt"
FileUtils.rm_rf(log_file)
Warabi.logger = ActiveSupport::Logger.new(log_file)

mediator = Mediator.new
mediator.placement_from_bod <<~EOT
後手の持駒：歩
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・v飛 ・ ・ ・ ・ ・ ・ ・|二
|v歩v歩v歩 ・ 馬v歩v歩v歩 ・|三
| ・ ・ ・ ・ ・ ・ ・ ・v歩|四
| 歩 ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| ・ 歩 歩 歩v馬 歩 歩 歩 歩|七
| ・ ・ ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
先手の持駒：歩二
手数＝8 △５七角成(13) まで

EOT
puts mediator

mediator.player_at(:black).evaluator.score # => 205
mediator.player_at(:black).brain.nega_alpha_run(depth_max: 1, log_skip_depth: 1) # => {:hand=>#<▲７一馬(53)>, :score=>2255, :eval_times=>6, :forecast=>[#<▲７一馬(53)>]}
# >> 後手の持駒：歩
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v銀v金v玉v金v銀v桂v香|一
# >> | ・v飛 ・ ・ ・ ・ ・ ・ ・|二
# >> |v歩v歩v歩 ・ 馬v歩v歩v歩 ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・v歩|四
# >> | 歩 ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ 歩 歩 歩v馬 歩 歩 歩 歩|七
# >> | ・ ・ ・ ・ ・ ・ ・ 飛 ・|八
# >> | 香 桂 銀 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >> 先手の持駒：歩二
# >> 手数＝8 まで
# >> 
# >> 先手番
