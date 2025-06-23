require "#{__dir__}/setup"
info = Analysis::AttackInfo.fetch("腰掛け金").static_kif_info
tp info.formatter.container.players.collect { |e| e.tag_bundle.to_h }
puts info.to_kif
