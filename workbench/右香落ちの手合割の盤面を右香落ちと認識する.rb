require "#{__dir__}/setup"
info = Parser.parse(<<~EOT)
手合割：右香落ち
△６二銀 ▲７六歩 △５四歩 ▲５六歩 △５三銀 ▲４八銀 △６四銀 ▲５七銀
EOT

Parser.parse(info.to_csa).to_kif.match?(/英春流かまいたち戦法/)  # => true
Parser.parse(info.to_kif).to_kif.match?(/英春流かまいたち戦法/)  # => true
Parser.parse(info.to_sfen).to_kif.match?(/英春流かまいたち戦法/) # => true
