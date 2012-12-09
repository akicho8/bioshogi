# -*- coding: utf-8 -*-
#
# 移動する駒の推測
#

begin
  require_relative "../lib/bushido"
rescue LoadError
  require File.expand_path(File.join(File.dirname(__FILE__), "../lib/bushido"))
end

include Bushido

field = Field.new
players = []
players << Player.new("先手", field, :lower)
players << Player.new("後手", field, :upper)
players.each(&:setup)
players[0].execute("7六歩")
players[1].execute("3四歩")
players[0].execute("2二角成")
players[0].pieces.collect(&:name) # => 
puts field
# ~> /Users/ikeda/src/bushido/lib/bushido.rb:794:in `execute': 7六に来れる駒が多すぎます。"7六歩" の表記を明確にしてください。(移動元候補: ▲9七歩, ▲8七歩, ▲7七歩, ▲6七歩, ▲5七歩, ▲4七歩, ▲3七歩, ▲2七歩, ▲1七歩) (Bushido::AmbiguousFormatError)
# ~> 	from -:19:in `<main>'
