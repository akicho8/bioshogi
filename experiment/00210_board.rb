require "./setup"

mediator = Mediator.new

mediator.board.all_clear
mediator.placement_from_preset("裸玉")
mediator.board.preset_info&.key    # => :十九枚落ち

mediator.board.all_clear
mediator.board.placement_from_hash(black: "平手", white: "裸玉")
mediator.board.preset_info&.key    # => :十九枚落ち

mediator.board.all_clear
mediator.board.placement_from_hash(black: "平手", white: "二十枚落ち")
mediator.board.placement_from_human("△５一玉")
mediator.board.preset_info&.key    # => :十九枚落ち

mediator.board.all_clear
mediator.board.placement_from_shape <<~EOT
+---------------------------+
| ・ ・ ・ ・v玉 ・ ・ ・ ・|一
| ・ ・ ・ ・ ・ ・ ・ ・ ・|二
| ・ ・ ・ ・ ・ ・ ・ ・ ・|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
EOT
mediator.board.preset_info&.key    # => :十九枚落ち
