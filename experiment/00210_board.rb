require "./setup"

xcontainer = Xcontainer.new

xcontainer.board.all_clear
xcontainer.placement_from_preset("裸玉")
xcontainer.board.preset_info&.key    # => :十九枚落ち

xcontainer.board.all_clear
xcontainer.board.placement_from_preset("裸玉")
xcontainer.board.preset_info&.key    # => :十九枚落ち

xcontainer.board.all_clear
xcontainer.board.placement_from_preset("二十枚落ち")
xcontainer.board.placement_from_human("△５一玉")
xcontainer.board.preset_info&.key    # => :十九枚落ち

xcontainer.board.all_clear
xcontainer.board.placement_from_shape <<~EOT
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
xcontainer.board.preset_info&.key    # => :十九枚落ち
