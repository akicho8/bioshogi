require "./example_helper"

mediator = Mediator.start
puts mediator.board

mediator.board["５五"]      # => nil
mediator.board["８八"]      # => <Warabi::Soldier "▲８八角">
mediator.board["８八"].name # => "▲８八角"
mediator.board["２八"].name # => "▲２八飛"
mediator.board["５九"].name # => "▲５九玉"

mediator.board.all_clear
mediator.board.set_from_preset_key("裸玉")
mediator.board.preset_key    # => :十九枚落ち
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
