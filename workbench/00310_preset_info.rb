require "#{__dir__}/setup"

PresetInfo["裸玉"].sorted_soldiers.collect(&:to_s)       # => ["▲９七歩", "▲９九香", "▲８七歩", "▲８八角", "▲８九桂", "▲７七歩", "▲７九銀", "▲６七歩", "▲６九金", "△５一玉", "▲５七歩", "▲５九玉", "▲４七歩", "▲４九金", "▲３七歩", "▲３九銀", "▲２七歩", "▲２八飛", "▲２九桂", "▲１七歩", "▲１九香"]
PresetInfo["二枚落ち"].declined_soldiers.collect(&:to_s) # => ["△８二飛", "△２二角"]

tp PresetInfo.collect { |e|
  container = Container::Basic.new
  container.placement_from_preset(e.key)
  [e.key, container.to_short_sfen]
}.to_h

tp PresetInfo.collect(&:to_short_sfen)

# >> |------------+-------------------------------------------------------------------------------|
# >> |       平手 | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 |
# >> |    5五将棋 | position sfen 4rbsgk/8p/9/4P4/4KGSBR/9/9/9/9 b - 1                            |
# >> |     香落ち | position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 |
# >> |   右香落ち | position sfen 1nsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 |
# >> |     角落ち | position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1   |
# >> |   飛車落ち | position sfen lnsgkgsnl/7b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1   |
# >> |   飛香落ち | position sfen lnsgkgsn1/7b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1   |
# >> |   二枚落ち | position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1     |
# >> |   三枚落ち | position sfen lnsgkgsn1/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1     |
# >> |   四枚落ち | position sfen 1nsgkgsn1/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1     |
# >> |   六枚落ち | position sfen 2sgkgs2/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1       |
# >> |   八枚落ち | position sfen 3gkg3/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1         |
# >> |   十枚落ち | position sfen 4k4/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1           |
# >> | 十九枚落ち | position sfen 4k4/9/9/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1                   |
# >> | 二十枚落ち | position sfen 9/9/9/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1                     |
# >> |------------+-------------------------------------------------------------------------------|
# >> |-------------------------------------------------------------------------------|
# >> | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 |
# >> | position sfen 4rbsgk/8p/9/4P4/4KGSBR/9/9/9/9 b - 1                            |
# >> | position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 |
# >> | position sfen 1nsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 |
# >> | position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1   |
# >> | position sfen lnsgkgsnl/7b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1   |
# >> | position sfen lnsgkgsn1/7b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1   |
# >> | position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1     |
# >> | position sfen lnsgkgsn1/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1     |
# >> | position sfen 1nsgkgsn1/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1     |
# >> | position sfen 2sgkgs2/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1       |
# >> | position sfen 3gkg3/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1         |
# >> | position sfen 4k4/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1           |
# >> | position sfen 4k4/9/9/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1                   |
# >> | position sfen 9/9/9/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1                     |
# >> |-------------------------------------------------------------------------------|
