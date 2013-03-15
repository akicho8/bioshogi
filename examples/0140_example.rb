# -*- coding: utf-8 -*-
# 棋譜の入力とkif形式のログ確認

require "./example_helper"

mediator = Mediator.start
mediator.piece_plot
[
  "７六歩", "８四歩", "７八金", "３二金",
].each{|input|
  mediator.execute(input)
}
puts mediator.board
pp mediator.simple_kif_logs
# ~> -:4:in `require_relative': cannot infer basepath (LoadError)
# ~> 	from -:4:in `<main>'
