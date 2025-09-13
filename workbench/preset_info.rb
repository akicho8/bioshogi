require "#{__dir__}/setup"
PresetInfo["二枚落ち"]                                                  # => <二枚落ち>
PresetInfo["二枚落ち"].sorted_soldiers.count                            # => 38
PresetInfo["二枚落ち"].location_split[:black]                           # => [<Bioshogi::Soldier "▲９七歩">, <Bioshogi::Soldier "▲９九香">, <Bioshogi::Soldier "▲８七歩">, <Bioshogi::Soldier "▲８八角">, <Bioshogi::Soldier "▲８九桂">, <Bioshogi::Soldier "▲７七歩">, <Bioshogi::Soldier "▲７九銀">, <Bioshogi::Soldier "▲６七歩">, <Bioshogi::Soldier "▲６九金">, <Bioshogi::Soldier "▲５七歩">, <Bioshogi::Soldier "▲５九玉">, <Bioshogi::Soldier "▲４七歩">, <Bioshogi::Soldier "▲４九金">, <Bioshogi::Soldier "▲３七歩">, <Bioshogi::Soldier "▲３九銀">, <Bioshogi::Soldier "▲２七歩">, <Bioshogi::Soldier "▲２八飛">, <Bioshogi::Soldier "▲２九桂">, <Bioshogi::Soldier "▲１七歩">, <Bioshogi::Soldier "▲１九香">]
PresetInfo["二枚落ち"].location_split[:white].count                     # => 18
PresetInfo["二枚落ち"].location_split[:white].collect(&:name).join(" ") # => "△９一香 △９三歩 △８一桂 △８三歩 △７一銀 △７三歩 △６一金 △６三歩 △５一玉 △５三歩 △４一金 △４三歩 △３一銀 △３三歩 △２一桂 △２三歩 △１一香 △１三歩"
