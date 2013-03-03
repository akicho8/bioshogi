# -*- coding: utf-8 -*-
# 棋譜の入力とkif形式のログ確認

require_relative "example_helper"

frame = LiveFrame.start
frame.piece_plot
[
  "７六歩", "８四歩", "７八金", "３二金",
].each{|input|
  frame.execute(input)
}
puts frame.board
pp frame.simple_kif_logs
# ~> -:4:in `require_relative': cannot infer basepath (LoadError)
# ~> 	from -:4:in `<main>'
