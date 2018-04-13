require "./example_helper"

# info = Parser.parse("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 2g2f")
info = Parser.parse("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 2g2e", typical_error_case: :embed)
mediator = info.mediator
puts mediator
records = mediator.current_player.brain(diver_class: NegaScoutDiver).interactive_deepning(time_limit: 3, depth_max_range: 0..8)
tp Brain.human_format(records)
record = records.first
hand = record[:hand]
mediator.execute(hand.to_sfen, executor_class: PlayerExecutorCpu)
puts mediator.to_sfen
# ~> /Users/ikeda/src/warabi/lib/warabi/player_executor_base.rb:83:in `raise_error': 【反則】▲２五歩(27)としましたが２七から２五に移動することはできません (Warabi::CandidateSoldiersNotInclude)
# ~> 手番: 先手
# ~> 指し手: 2e2g
# ~> 棋譜: 
# ~> 後手の持駒：なし
# ~>   ９ ８ ７ ６ ５ ４ ３ ２ １
# ~> +---------------------------+
# ~> |v香v桂v銀v金v玉v金v銀v桂v香|一
# ~> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# ~> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# ~> | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# ~> | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# ~> | 香 桂 銀 金 玉 金 銀 桂 香|九
# ~> +---------------------------+
# ~> 先手の持駒：なし
# ~> 手数＝0 まで
# ~> 
# ~> 先手番
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/player_executor_base.rb:33:in `execute'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/player.rb:20:in `execute'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/mediator_executor.rb:11:in `block in execute'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/mediator_executor.rb:10:in `each'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/mediator_executor.rb:10:in `execute'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/parser/base.rb:187:in `block in mediator_run_all'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/parser/base.rb:177:in `each'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/parser/base.rb:177:in `mediator_run_all'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/parser/base.rb:131:in `block in mediator'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/parser/base.rb:129:in `tap'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/parser/base.rb:129:in `mediator'
# ~> 	from -:5:in `<main>'
