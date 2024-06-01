require "./setup"

info = Bioshogi::Parser.parse("▲２六歩 △３四歩 ▲２五歩")
info.formatter.container.to_ki2_a.last     # => "▲２五歩"

