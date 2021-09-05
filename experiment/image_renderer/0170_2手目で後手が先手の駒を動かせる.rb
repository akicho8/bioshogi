require "../example_helper"

info = Parser.parse("position startpos moves 2g2f 3i4h", validate_enable: false)
puts info.mediator.board
object = info.image_renderer({width: 800, height: 800})
object.display
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v銀v金v玉v金v銀v桂v香|一
# >> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ 歩 ・|六
# >> | 歩 歩 歩 歩 歩 歩 歩 ・ 歩|七
# >> | ・ 角 ・ ・ ・ 銀 ・ 飛 ・|八
# >> | 香 桂 銀 金 玉 金 ・ 桂 香|九
# >> +---------------------------+
