require "../setup"

Basic.player_test_soldier_names(init: "21飛", execute: "11龍") rescue $! # => #<Bioshogi::MovableBattlerNotFound: 【反則】先手の手番で１一に移動できる龍が見つかりません。「１一飛成」の間違いかもしれません
