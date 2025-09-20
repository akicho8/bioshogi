require "#{__dir__}/setup"

container = Container::Basic.new

container.board.all_clear
container.placement_from_preset("十九枚落ち")
container.board.preset_info&.key    # => :十九枚落ち

container.board.all_clear
container.board.placement_from_preset("十九枚落ち")
container.board.preset_info&.key    # => :十九枚落ち

container.board.all_clear
container.board.placement_from_preset("二十枚落ち")
container.board.placement_from_human("△５一玉")
container.board.preset_info&.key    # => :十九枚落ち

container.board.all_clear
container.board.placement_from_shape <<~EOT
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
container.board.preset_info&.key    # => :十九枚落ち
