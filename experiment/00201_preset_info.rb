require "./example_helper"

tp PresetInfo.collect { |e|
  mediator = Mediator.new
  mediator.board.placement_from_preset(e.key)
  [e.key, mediator.to_long_sfen]
}.to_h
# >> |------------+----------------------------------------------------------------------|
# >> |       平手 | sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 |
# >> |     香落ち | sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 |
# >> |   右香落ち | sfen 1nsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 |
# >> |     角落ち | sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1   |
# >> |   飛車落ち | sfen lnsgkgsnl/7b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1   |
# >> | 飛車香落ち | sfen lnsgkgsn1/7b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1   |
# >> |   二枚落ち | sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1     |
# >> |   三枚落ち | sfen lnsgkgsn1/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1     |
# >> |   四枚落ち | sfen 1nsgkgsn1/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1     |
# >> |   六枚落ち | sfen 2sgkgs2/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1       |
# >> |   八枚落ち | sfen 3gkg3/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1         |
# >> |   十枚落ち | sfen 4k4/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1           |
# >> | 十九枚落ち | sfen 4k4/9/9/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1                   |
# >> | 二十枚落ち | sfen 9/9/9/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1                     |
# >> |------------+----------------------------------------------------------------------|
