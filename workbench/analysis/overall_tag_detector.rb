require "#{__dir__}/setup"

puts Bioshogi::Parser.parse("68銀").to_kif
# >> ["/Users/ikeda/src/bioshogi/lib/bioshogi/analysis/overall_tag_detector.rb:9", :initialize]
# >> 先手の戦法：嬉野流
# >> 先手の棋風：王道
# >> 手合割：平手
# >> 手数----指手---------消費時間--
# >>    1 ６八銀(79)
# >> *▲戦法：嬉野流
# >>    2 投了
# >> まで1手で先手の勝ち
