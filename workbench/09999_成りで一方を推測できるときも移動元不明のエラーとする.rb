require "#{__dir__}/setup"

info = Parser.parse(<<~EOT)
後手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
| ・ ・ ・ ・ ・ ・ ・ 銀 ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ 銀 |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
+---------------------------+
先手の持駒：なし

14銀成
EOT

puts info.to_kif
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor/error_handler.rb:12:in 'Bioshogi::PlayerExecutor::ErrorHandler#call': １四に移動できる駒が2つありますが表記が曖昧なため特定できません。移動元は「２三の銀」か「１五の銀」のどっちでしょう？ (Bioshogi::AmbiguousFormatError)
# ~> 手番: 先手
# ~> 指し手: 14銀成
# ~> 棋譜:
# ~> 
# ~> 後手の持駒：なし
# ~>   ９ ８ ７ ６ ５ ４ ３ ２ １
# ~> +---------------------------+
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|一
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# ~> | ・ ・ ・ ・ ・ ・ ・ 銀 ・|三
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ 銀|五
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# ~> +---------------------------+
# ~> 先手の持駒：なし
# ~> 手数＝0 まで
# ~> 先手番
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor/base.rb:39:in 'Bioshogi::PlayerExecutor::Base#perform_validations'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor/base.rb:44:in 'Bioshogi::PlayerExecutor::Base#execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player.rb:26:in 'Bioshogi::Player#execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container/execute_methods.rb:42:in 'block in Bioshogi::Container::ExecuteMethods#execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container/execute_methods.rb:41:in 'Array#each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container/execute_methods.rb:41:in 'Bioshogi::Container::ExecuteMethods#execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:27:in 'block in Bioshogi::Formatter::Runner#call'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:17:in 'Array#each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:17:in 'Enumerator#with_index'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:17:in 'Bioshogi::Formatter::Runner#call'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:210:in 'Bioshogi::Formatter::Core#container_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:113:in 'block in Bioshogi::Formatter::Core#container'
# ~> 	from <internal:kernel>:91:in 'Kernel#tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:111:in 'Bioshogi::Formatter::Core#container'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:69:in 'Bioshogi::Formatter::Core#container_run_once'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/kif_ki2_shared.rb:26:in 'Bioshogi::Formatter::KifKi2Shared#to_s'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:31:in 'Bioshogi::Formatter::Core#to_kif'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:29:in 'Bioshogi::Parser::Base#to_kif'
# ~> 	from -:22:in '<main>'
