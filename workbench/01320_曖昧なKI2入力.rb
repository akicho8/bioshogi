require "#{__dir__}/setup"

info = Parser.parse("foo")
puts info.to_ki2
# >> まで0手で後手の勝ち
