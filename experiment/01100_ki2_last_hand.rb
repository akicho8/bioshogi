require "./setup"

info = Bioshogi::Parser.parse("▲２六歩 △３四歩 ▲２五歩")
info.mediator.to_ki2_a.last     # => "▲２五歩"

