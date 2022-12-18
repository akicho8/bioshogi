require "../setup"

container = Container::Basic.start
container.execute("▲２六歩")
container.execute("△３四歩")
player = container.player_at(:black)
player_executor = PlayerExecutorHuman.new(player, "▲５五銀")
player_executor.execute

container = Container::Basic.start
container.execute("▲22角成")    # => 
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:131:in `raise_error': ５五に移動できる銀がないため打の省略形と考えましたが銀を持っていません。手番が間違っているのかもしれません (Bioshogi::HoldPieceNotFound2)
# ~> 手番: 先手
# ~> 指し手: ▲５五銀
# ~> 棋譜: ２六歩(27) ３四歩(33)
# ~> 
# ~> 後手の持駒：なし
# ~>   ９ ８ ７ ６ ５ ４ ３ ２ １
# ~> +---------------------------+
# ~> |v香v桂v銀v金v玉v金v銀v桂v香|一
# ~> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# ~> |v歩v歩v歩v歩v歩v歩 ・v歩v歩|三
# ~> | ・ ・ ・ ・ ・ ・v歩 ・ ・|四
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# ~> | ・ ・ ・ ・ ・ ・ ・ 歩 ・|六
# ~> | 歩 歩 歩 歩 歩 歩 歩 ・ 歩|七
# ~> | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# ~> | 香 桂 銀 金 玉 金 銀 桂 香|九
# ~> +---------------------------+
# ~> 先手の持駒：なし
# ~> 手数＝2 △３四歩(33) まで
# ~> 
# ~> 先手番
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:37:in `perform_validations'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:42:in `execute'
# ~> 	from -:8:in `<main>'
