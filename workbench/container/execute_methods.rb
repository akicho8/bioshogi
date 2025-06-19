require "#{__dir__}/setup"

# TagEmbed.new(self, container).call

container = Bioshogi::Container.create
tp container.params
container.placement_from_preset("平手")
puts container
# >> |-------------------------+-----------------|
# >> |        analysis_feature | false           |
# >> | analysis_motion_feature | false           |
# >> |            ki2_function | true            |
# >> |        validate_feature | true            |
# >> |      double_pawn_detect | true            |
# >> |             warp_detect | true            |
# >> |             board_class | Bioshogi::Board |
# >> |-------------------------+-----------------|
# >> 後手の持駒：なし
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v銀v金v玉v金v銀v桂v香|一
# >> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# >> | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# >> | 香 桂 銀 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >> 先手の持駒：なし
# >> 手数＝0 まで
# >> 先手番
