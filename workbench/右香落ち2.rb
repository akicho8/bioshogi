require "#{__dir__}/setup"
info = Parser.parse(<<~EOT)
手合割：右香落ち
上手番

△７四歩
まで1手で上手の勝ち
EOT
puts info.to_kif
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor/error_handler.rb:12:in 'Bioshogi::PlayerExecutor::ErrorHandler#call': 【反則】下手の手番で上手が着手しました (Bioshogi::DifferentTurnCommonError)
# ~> 手番: 下手
# ~> 指し手: △７四歩
# ~> 棋譜:
# ~> 
# ~> 上手の持駒：なし
# ~>   ９ ８ ７ ６ ５ ４ ３ ２ １
# ~> +---------------------------+
# ~> | ・v桂v銀v金v玉v金v銀v桂v香|一
# ~> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# ~> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# ~> | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# ~> | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# ~> | 香 桂 銀 金 玉 金 銀 桂 香|九
# ~> +---------------------------+
# ~> 下手の持駒：なし
# ~> 手数＝1 まで
# ~> 下手番
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor/base.rb:38:in 'Bioshogi::PlayerExecutor::Base#perform_validations'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor/base.rb:43:in 'Bioshogi::PlayerExecutor::Base#execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player.rb:26:in 'Bioshogi::Player#execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container/execute_methods.rb:42:in 'block in Bioshogi::Container::ExecuteMethods#execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container/execute_methods.rb:41:in 'Array#each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container/execute_methods.rb:41:in 'Bioshogi::Container::ExecuteMethods#execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:27:in 'block in Bioshogi::Formatter::Runner#call'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:17:in 'Array#each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:17:in 'Enumerator#with_index'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:17:in 'Bioshogi::Formatter::Runner#call'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:202:in 'Bioshogi::Formatter::Core#container_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:113:in 'block in Bioshogi::Formatter::Core#container'
# ~> 	from <internal:kernel>:91:in 'Kernel#tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:111:in 'Bioshogi::Formatter::Core#container'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:69:in 'Bioshogi::Formatter::Core#container_run_once'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/kif_ki2_shared.rb:26:in 'Bioshogi::Formatter::KifKi2Shared#to_s'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:31:in 'Bioshogi::Formatter::Core#to_kif'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:29:in 'Bioshogi::Parser::Base#to_kif'
# ~> 	from -:9:in '<main>'
