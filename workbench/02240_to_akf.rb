require "#{__dir__}/setup"
info = Parser.parse("先手：alice\n先手の持駒：銀\n\n▲55銀打")
puts info.to_kif
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor/error_handler.rb:12:in 'Bioshogi::PlayerExecutor::ErrorHandler#call': 打を明示しましたが銀を持っていません (Bioshogi::HoldPieceNotFound)
# ~> 手番: 先手
# ~> 指し手: ▲55銀打
# ~> 棋譜:
# ~> 
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
# ~> 先手番
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor/base.rb:38:in 'Bioshogi::PlayerExecutor::Base#perform_validations'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor/base.rb:43:in 'Bioshogi::PlayerExecutor::Base#execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player.rb:25:in 'Bioshogi::Player#execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container/execute_methods.rb:31:in 'block in Bioshogi::Container::ExecuteMethods#execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container/execute_methods.rb:30:in 'Array#each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container/execute_methods.rb:30:in 'Bioshogi::Container::ExecuteMethods#execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:26:in 'block in Bioshogi::Formatter::Runner#call'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:16:in 'Array#each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:16:in 'Enumerator#with_index'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:16:in 'Bioshogi::Formatter::Runner#call'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:175:in 'Bioshogi::Formatter::Core#container_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:106:in 'block in Bioshogi::Formatter::Core#container'
# ~> 	from <internal:kernel>:91:in 'Kernel#tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:104:in 'Bioshogi::Formatter::Core#container'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:69:in 'Bioshogi::Formatter::Core#container_run_once'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/kif_ki2_shared.rb:26:in 'Bioshogi::Formatter::KifKi2Shared#to_s'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:31:in 'Bioshogi::Formatter::Core#to_kif'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:29:in 'Bioshogi::Parser::Base#to_kif'
# ~> 	from -:3:in '<main>'
