require "#{__dir__}/setup"
info = Bioshogi::Parser.parse(<<~EOT, { validate_feature: false, analysis_feature: true })
P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
P2 * -HI *  *  *  *  *  *  *
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  *
P5 *  *  *  *  *  *  *  *  *
P6 *  *  *  *  *  *  *  *  *
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI *
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
-
+7968GI,T0
-8232HI,T0
%TORYO
EOT
puts info.to_kif

# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/assertion.rb:13:in 'Bioshogi::Assertion#assert': assert failed: false (Bioshogi::MustNotHappen)
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/analysis/motion_detector.rb:768:in 'block (2 levels) in <class:MotionDetector>'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/analysis/executer_dsl.rb:38:in 'Bioshogi::Analysis::ExecuterDsl#and_cond'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/analysis/motion_detector.rb:737:in 'block in <class:MotionDetector>'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/analysis/motion_analyzer.rb:20:in 'BasicObject#instance_exec'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/analysis/motion_analyzer.rb:20:in 'block (2 levels) in Bioshogi::Analysis::MotionAnalyzer#call'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/analysis/executer_dsl.rb:31:in 'block in Bioshogi::Analysis::ExecuterDsl#perform_block'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/analysis/executer_dsl.rb:30:in 'Kernel#catch'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/analysis/executer_dsl.rb:30:in 'Bioshogi::Analysis::ExecuterDsl#perform_block'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/analysis/motion_analyzer.rb:19:in 'block in Bioshogi::Analysis::MotionAnalyzer#call'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/analysis/motion_analyzer.rb:17:in 'Array#each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/analysis/motion_analyzer.rb:17:in 'Bioshogi::Analysis::MotionAnalyzer#call'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/analysis/analyzer_mod.rb:58:in 'Bioshogi::Analysis::AnalyzerMod#perform_analyzer'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor/base.rb:66:in 'Bioshogi::PlayerExecutor::Base#execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player.rb:26:in 'Bioshogi::Player#execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container/execute_methods.rb:42:in 'block in Bioshogi::Container::ExecuteMethods#execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container/execute_methods.rb:41:in 'Array#each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container/execute_methods.rb:41:in 'Bioshogi::Container::ExecuteMethods#execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:27:in 'block in Bioshogi::Formatter::Runner#call'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:17:in 'Array#each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:17:in 'Enumerator#with_index'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:17:in 'Bioshogi::Formatter::Runner#call'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:182:in 'Bioshogi::Formatter::Core#container_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:113:in 'block in Bioshogi::Formatter::Core#container'
# ~> 	from <internal:kernel>:91:in 'Kernel#tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:111:in 'Bioshogi::Formatter::Core#container'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:69:in 'Bioshogi::Formatter::Core#container_run_once'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/kif_ki2_shared.rb:26:in 'Bioshogi::Formatter::KifKi2Shared#to_s'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:31:in 'Bioshogi::Formatter::Core#to_kif'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:29:in 'Bioshogi::Parser::Base#to_kif'
# ~> 	from -:17:in '<main>'
